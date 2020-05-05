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
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode, flow: GridFlow) -> PositionsPreference
}

extension LayoutArranging {
    
    func arrange(spanPreferences: [SpanPreference], fixedTracksCount: Int, flow: GridFlow, packing: GridPacking) -> LayoutArrangement {
        guard fixedTracksCount > 0 else { return .zero }
            
        var result: [ArrangedItem] = []
        var occupiedIndices: [GridIndex] = []
        
        var lastIndex: GridIndex = .zero
        var growingTracksCount = 0

        for spanPreference in spanPreferences {
            guard
                spanPreference.span[keyPath: flow.fixedIndex] <= fixedTracksCount,
                let gridItem = spanPreference.item
            else {
                continue
            } // TODO: Reduce span
            
            var currentIndex: GridIndex
            
            switch packing {
            case .sparse:
                currentIndex = lastIndex
            case .dense:
                currentIndex = .zero // TODO: Improve dense algorithm
            }
            while occupiedIndices.contains(currentIndex, rowSpan: spanPreference.span.row, columnSpan: spanPreference.span.column)
                || currentIndex[keyPath: flow.fixedIndex] + spanPreference.span[keyPath: flow.fixedIndex] > fixedTracksCount {
                    currentIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
            }

            for row in currentIndex.row..<currentIndex.row + spanPreference.span.row {
                for column in currentIndex.column..<currentIndex.column + spanPreference.span.column {
                    occupiedIndices.append(GridIndex(row: row, column: column))
                }
            }
            
            let startIndex = currentIndex
            let endIndex = GridIndex(row: startIndex.row + spanPreference.span.row - 1,
                                           column: startIndex.column + spanPreference.span.column - 1)

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
    
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode, flow: GridFlow) -> PositionsPreference {
        let growingTracksSizes: [CGFloat] = self.calculateSizes(position: position,
                                                                arrangement: arrangement,
                                                                contentMode: contentMode,
                                                                flow: flow)
        let fixedTracksSizes = self.calculateSizes(tracks: tracks, boundingLength: boundingSize[keyPath: flow.fixedSize])
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
    
    private func calculateSizes(tracks: [TrackSize], boundingLength: CGFloat) -> [CGFloat] {
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
        
        let correctedLength = boundingLength - CGFloat(totalConsts)
        let fractionSize = correctedLength / CGFloat(fractionCount)

        return tracks.map { track in
            switch track {
            case .fr(let fraction):
                return CGFloat(fraction) * fractionSize
            case .const(let constLength):
                return CGFloat(constLength)
            }
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
        var fixedSize = self[keyPath: flow.fixedIndexIndex]
        var growingSize = self[keyPath: flow.growingIndexIndex]
        
        fixedSize += 1
        if fixedSize >= tracksCount {
            fixedSize = 0
            growingSize += 1
        }
        
        var nextIndex = GridIndex.zero
        nextIndex[keyPath: flow.fixedIndexIndex] = fixedSize
        nextIndex[keyPath: flow.growingIndexIndex] = growingSize
        return nextIndex
    }
}

extension Array where Element == GridIndex {
    fileprivate func contains(_ startIndex: GridIndex, rowSpan: Int, columnSpan: Int) -> Bool {
        for row in startIndex.row..<startIndex.row + rowSpan {
            for column in startIndex.column..<startIndex.column + columnSpan {
                if self.contains(GridIndex(row: row, column: column)) {
                    return true
                }
            }
        }
        
        return false
    }
}
