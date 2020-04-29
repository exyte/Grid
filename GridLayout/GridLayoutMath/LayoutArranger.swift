//
//  LayoutArranger.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation
import CoreGraphics

protocol LayoutArranger {
    /// Arranges grid items into layout arrangement that specifies relations between abstract position in grid view and specific item
    /// - Parameters:
    ///   - items: Grid items to arrange. They could specify row and columns spans
    ///   - columnsCount: Total count of columns in grid view
    func arrange(spanPreferences: [SpanPreference], tracksCount: Int, flow: GridFlow) -> LayoutArrangement
    
    /// Recalculates positions based on layout arrangement and bounding size
    /// - Parameters:
    ///   - items: Items to reposition
    ///   - arrangement: Previously calculated arrangement
    ///   - size: Bounding size
    ///   - tracks: Sizes of tracks
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode, flow: GridFlow) -> PositionsPreference
}

class LayoutArrangerImpl: LayoutArranger {
    
    func arrange(spanPreferences: [SpanPreference], tracksCount: Int, flow: GridFlow) -> LayoutArrangement {
        guard tracksCount > 0 else { return LayoutArrangement(columnsCount: tracksCount, rowsCount: 0, items: []) }
            
        var result: [ArrangedItem] = []
        var occupiedPoints: [GridPoint] = []
        
        var lastPoint: GridPoint = .zero
        var orthogonalTracksCount = 0

        for spanPreference in spanPreferences {
            guard
                spanPreference.span[keyPath: flow.fixedIndex] <= tracksCount,
                let gridItem = spanPreference.item
            else {
                continue
            } // TODO: Reduce span
            
            while occupiedPoints.contains(lastPoint, rowSpan: spanPreference.span.row, columnSpan: spanPreference.span.column)
                || lastPoint[keyPath: flow.fixedIndex] + spanPreference.span[keyPath: flow.fixedIndex] > tracksCount {
                    lastPoint = lastPoint.nextPoint(tracksCount: tracksCount, flow: flow)
            }

            for row in lastPoint.row..<lastPoint.row + spanPreference.span.row {
                for column in lastPoint.column..<lastPoint.column + spanPreference.span.column {
                    occupiedPoints.append(GridPoint(row: row, column: column))
                }
            }
            
            let startPoint = lastPoint
            let endPoint = GridPoint(row: startPoint.row + spanPreference.span.row - 1,
                                           column: startPoint.column + spanPreference.span.column - 1)

            let arrangedItem = ArrangedItem(gridItem: gridItem, startPoint: startPoint, endPoint: endPoint)
            orthogonalTracksCount = max(orthogonalTracksCount, arrangedItem.endPoint[keyPath: flow.growingIndex] + 1)
            result.append(arrangedItem)
            lastPoint = lastPoint.nextPoint(tracksCount: tracksCount, flow: flow)
        }
        
        return LayoutArrangement(columnsCount: tracksCount, rowsCount: orthogonalTracksCount, items: result)
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
                growingPosition = growingSize * CGFloat(arrangedItem.startPoint[keyPath: flow.growingIndex])
            case .scroll:
                itemGrowingSize = (arrangedItem.startPoint[keyPath: flow.growingIndex]...arrangedItem.endPoint[keyPath: flow.growingIndex]).reduce(0, { result, index in
                    return result + growingTracksSizes[index]
                })
                let centringCorrection = (itemGrowingSize - positionedItem.bounds.size[keyPath: flow.growingSize]) / 2
                growingPosition = (0..<arrangedItem.startPoint[keyPath: flow.growingIndex]).reduce(0, { result, index in
                    return result + growingTracksSizes[index]
                }) + centringCorrection
            }

            let fixedTrackStart = fixedTracksSizes[0..<arrangedItem.startPoint[keyPath: flow.fixedIndex]].reduce(0, +)
            let fixedTrackSize = fixedTracksSizes[arrangedItem.startPoint[keyPath: flow.fixedIndex]...arrangedItem.endPoint[keyPath: flow.fixedIndex]].reduce(0, +)
            
            var newBounds = CGRect.zero
            newBounds.size[keyPath: flow.growingSize] = itemGrowingSize
            newBounds.size[keyPath: flow.fixedSize] = fixedTrackSize
            newBounds.origin[keyPath: flow.growingCGPointIndex] = growingPosition
            newBounds.origin[keyPath: flow.fixedCGPointIndex] = fixedTrackStart

            newPositions.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
        }
        
        let totalGrowingSize = growingTracksSizes.reduce(0, +)
        var totalSize = CGSize.zero
        totalSize[keyPath: flow.fixedSize] = boundingSize[keyPath: flow.fixedSize]
        totalSize[keyPath: flow.growingSize] = totalGrowingSize
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
        var sizes: [CGFloat] = .init(repeating: 0, count: arrangement.rowsCount)
        if case .scroll = contentMode {
            for positionedItem in position.items {
                guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
                
                let itemSelfSize = positionedItem.bounds.size[keyPath: flow.growingSize]
                let itemRangeStart = arrangedItem.startPoint[keyPath: flow.growingIndex]
                let itemRangeEnd = arrangedItem.endPoint[keyPath: flow.growingIndex]
                for index in itemRangeStart...itemRangeEnd {
                    let growingCount = arrangedItem[keyPath: flow.arrangedItemGrowingCount]
                    sizes[index] = max(sizes[index], itemSelfSize / CGFloat(growingCount))
                }
            }
        }
        return sizes
    }
}

extension GridPoint {
    fileprivate func nextPoint(tracksCount: Int, flow: GridFlow) -> GridPoint {
        var fixedSize = self[keyPath: flow.fixedPointIndex]
        var growingSize = self[keyPath: flow.growingPointIndex]
        
        fixedSize += 1
        if fixedSize >= tracksCount {
            fixedSize = 0
            growingSize += 1
        }
        
        var nextPoint = GridPoint.zero
        nextPoint[keyPath: flow.fixedPointIndex] = fixedSize
        nextPoint[keyPath: flow.growingPointIndex] = growingSize
        return nextPoint
    }
}

extension Array where Element == GridPoint {
    fileprivate func contains(_ startPoint: GridPoint, rowSpan: Int, columnSpan: Int) -> Bool {
        for row in startPoint.row..<startPoint.row + rowSpan {
            for column in startPoint.column..<startPoint.column + columnSpan {
                if self.contains(GridPoint(row: row, column: column)) {
                    return true
                }
            }
        }
        
        return false
    }
}
