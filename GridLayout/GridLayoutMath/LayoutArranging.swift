//
//  LayoutArranging.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation
import CoreGraphics

protocol LayoutArranging {
    /// Arranges grid items into layout arrangement that specifies relations between abstract position in grid view and specific item
    /// - Parameters:
    ///   - spanPreferences: Grid items to arrange. They could specify row and columns spans
    ///   - fixedTracksCount: Total count of fixed tracks in grid view
    ///   - flow: Distribution order of grid items
    ///   - packing: Defines placement algorithm
    func arrange(spanPreferences: [SpanPreference], fixedTracksCount: Int, flow: GridFlow, packing: GridPacking) -> LayoutArrangement
    
    /// Recalculates positions based on layout arrangement and bounding size
    /// - Parameters:
    ///   - position: Items to reposition
    ///   - arrangement: Previously calculated arrangement
    ///   - boundingSize: Bounding size
    ///   - tracks: Sizes of tracks
    ///   - contentMode: Where the content will be scrolled or filled inside a grid
    ///   - flow: Distribution order of grid items
    ///   - spacing: Spacing between items
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode, flow: GridFlow, spacing: CGFloat) -> PositionsPreference
}

extension LayoutArranging {
    
    func arrange(spanPreferences: [SpanPreference], fixedTracksCount: Int, flow: GridFlow, packing: GridPacking) -> LayoutArrangement {
        guard fixedTracksCount > 0 else { return .zero }
            
        var result: [ArrangedItem] = []
        var occupiedIndices: [GridIndex] = []
        
        var lastIndex: GridIndex = .zero
        var growingTracksCount = 0

        for spanPreference in spanPreferences {
            guard let gridItem = spanPreference.item else { continue }
            
            var correctedSpan = spanPreference.span
            correctedSpan[keyPath: flow.fixedSpanIndex] = min(fixedTracksCount, correctedSpan[keyPath: flow.fixedSpanIndex])
            var currentIndex: GridIndex
            
            switch packing {
            case .sparse:
                currentIndex = lastIndex
            case .dense:
                currentIndex = .zero // TODO: Improve dense algorithm
            }
            
            while occupiedIndices.contains(currentIndex, rowSpan: correctedSpan.row, columnSpan: correctedSpan.column)
                || currentIndex[keyPath: flow.fixedIndex] + correctedSpan[keyPath: flow.fixedSpanIndex] > fixedTracksCount {
                    currentIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
            }

            for row in currentIndex.row..<currentIndex.row + correctedSpan.row {
                for column in currentIndex.column..<currentIndex.column + correctedSpan.column {
                    occupiedIndices.append(GridIndex(column: column, row: row))
                }
            }
            
            let startIndex = currentIndex
            var endIndex: GridIndex = .zero
            endIndex[keyPath: flow.fixedIndex] = startIndex[keyPath: flow.fixedIndex] + correctedSpan[keyPath: flow.fixedSpanIndex] - 1
            endIndex[keyPath: flow.growingIndex] = startIndex[keyPath: flow.growingIndex] + correctedSpan[keyPath: flow.growingSpanIndex] - 1

            let arrangedItem = ArrangedItem(gridItem: gridItem, startIndex: startIndex, endIndex: endIndex)
            growingTracksCount = max(growingTracksCount, arrangedItem.endIndex[keyPath: flow.growingIndex] + 1)
            result.append(arrangedItem)
            lastIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
        }
        var arrangement = LayoutArrangement(columnsCount: 0, rowsCount: 0, items: result)
        arrangement[keyPath: flow.fixedArrangementCount] = fixedTracksCount
        arrangement[keyPath: flow.growingArrangementCount] = growingTracksCount
        return arrangement
    }
    
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode, flow: GridFlow, spacing: CGFloat) -> PositionsPreference {
        let growingTracksSizes: [CGFloat] = self.calculateSizes(position: position,
                                                                arrangement: arrangement,
                                                                contentMode: contentMode,
                                                                flow: flow)
        let fixedTracksSizes = self.calculateSizes(tracks: tracks, boundingLength: boundingSize[keyPath: flow.fixedSize], spacing: spacing)
        var newPositions: [PositionedItem] = []
        
        for positionedItem in position.items {
            guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
            let itemGrowingSize: CGFloat
            let growingPosition: CGFloat
            
            switch contentMode {
            case .fill:
                let growingSize = boundingSize[keyPath: flow.growingSize] / CGFloat(arrangement[keyPath: flow.growingArrangementCount])
                itemGrowingSize = growingSize * CGFloat(arrangedItem[keyPath: flow.arrangedItemGrowingCount])
                growingPosition = growingSize * CGFloat(arrangedItem.startIndex[keyPath: flow.growingIndex])
            case .scroll:
                itemGrowingSize = (arrangedItem.startIndex[keyPath: flow.growingIndex]...arrangedItem.endIndex[keyPath: flow.growingIndex]).reduce(0, { result, index in
                    return result + growingTracksSizes[index]
                })
                let centringCorrection = (itemGrowingSize - positionedItem.bounds.size[keyPath: flow.growingSize]) / 2
                growingPosition = (0..<arrangedItem.startIndex[keyPath: flow.growingIndex]).reduce(0, { result, index in
                    return result + growingTracksSizes[index]
                }) + centringCorrection
            }

            let fixedTrackStart = fixedTracksSizes[0..<arrangedItem.startIndex[keyPath: flow.fixedIndex]].reduce(0, +)
            let fixedTrackSize = fixedTracksSizes[arrangedItem.startIndex[keyPath: flow.fixedIndex]...arrangedItem.endIndex[keyPath: flow.fixedIndex]].reduce(0, +)
            
            var newBounds = CGRect.zero
            newBounds.size[keyPath: flow.growingSize] = itemGrowingSize.rounded()
            newBounds.size[keyPath: flow.fixedSize] = fixedTrackSize.rounded()
            newBounds.origin[keyPath: flow.growingCGPointIndex] = growingPosition.rounded()
            newBounds.origin[keyPath: flow.fixedCGPointIndex] = fixedTrackStart.rounded()

            newPositions.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
        }
        
        let totalGrowingSize = growingTracksSizes.reduce(0, +)
        var totalSize = CGSize.zero
        totalSize[keyPath: flow.fixedSize] = boundingSize[keyPath: flow.fixedSize].rounded()
        totalSize[keyPath: flow.growingSize] = totalGrowingSize.rounded()
        return PositionsPreference(items: newPositions, size: totalSize)
    }
    
    private func calculateSizes(tracks: [TrackSize], boundingLength: CGFloat, spacing: CGFloat) -> [CGFloat] {
        var fractionCount = 0
        var totalConsts = 0
        
        for track in tracks {
            switch track {
            case .fr(let fraction):
                fractionCount += fraction
            case .const(let constLength):
                totalConsts += constLength
            }
        }
        
        let correctedLength = boundingLength - CGFloat(totalConsts) - CGFloat(tracks.count - 1) * spacing
        let fractionSize = correctedLength / CGFloat(fractionCount)

        return tracks.enumerated().map { index, track in
            var trackSize: CGFloat
            switch track {
            case .fr(let fraction):
                trackSize = CGFloat(fraction) * fractionSize
            case .const(let constLength):
                trackSize = CGFloat(constLength)
            }
            
            if index != 0 {
                trackSize += spacing
            }
            return trackSize
        }
    }
    
    private func calculateSizes(position: PositionsPreference, arrangement: LayoutArrangement,
                                contentMode: GridContentMode, flow: GridFlow) -> [CGFloat] {
        var sizes: [CGFloat] = .init(repeating: 0, count: arrangement[keyPath: flow.growingArrangementCount])
        if case .scroll = contentMode {
            for positionedItem in position.items {
                guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
                
                let itemSelfSize = positionedItem.bounds.size[keyPath: flow.growingSize]
                let itemRangeStart = arrangedItem.startIndex[keyPath: flow.growingIndex]
                let itemRangeEnd = arrangedItem.endIndex[keyPath: flow.growingIndex]
                for index in itemRangeStart...itemRangeEnd {
                    let growingCount = arrangedItem[keyPath: flow.arrangedItemGrowingCount]
                    sizes[index] = max(sizes[index], itemSelfSize / CGFloat(growingCount))
                }
            }
        }
        return sizes
    }
}

extension GridIndex {
    fileprivate func nextIndex(tracksCount: Int, flow: GridFlow) -> GridIndex {
        var fixedSize = self[keyPath: flow.fixedIndex]
        var growingSize = self[keyPath: flow.growingIndex]
        
        fixedSize += 1
        if fixedSize >= tracksCount {
            fixedSize = 0
            growingSize += 1
        }
        
        var nextIndex = GridIndex.zero
        nextIndex[keyPath: flow.fixedIndex] = fixedSize
        nextIndex[keyPath: flow.growingIndex] = growingSize
        return nextIndex
    }
}

extension Array where Element == GridIndex {
    fileprivate func contains(_ startIndex: GridIndex, rowSpan: Int, columnSpan: Int) -> Bool {
        for row in startIndex.row..<startIndex.row + rowSpan {
            for column in startIndex.column..<startIndex.column + columnSpan {
                if self.contains(GridIndex(column: column, row: row)) {
                    return true
                }
            }
        }
        
        return false
    }
}
