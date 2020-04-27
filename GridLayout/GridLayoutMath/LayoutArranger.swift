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
    func arrange(spanPreferences: [SpanPreference], columnsCount: Int) -> LayoutArrangement
    
    /// Recalculates positions based on layout arrangement and bounding size
    /// - Parameters:
    ///   - items: Items to reposition
    ///   - arrangement: Previously calculated arrangement
    ///   - size: Bounding size
    ///   - tracks: Sizes of tracks
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode) -> PositionsPreference
}

class LayoutArrangerImpl: LayoutArranger {
    
    func arrange(spanPreferences: [SpanPreference], columnsCount: Int) -> LayoutArrangement {
        guard columnsCount > 0 else { return LayoutArrangement(columnsCount: columnsCount, rowsCount: 0, items: []) }
            
        var result: [ArrangedItem] = []
        var occupiedPoints: [GridPoint] = []
        
        var lastPoint: GridPoint = .zero
        var rowsCount = 0

        for spanPreference in spanPreferences {
            guard
                spanPreference.span.column <= columnsCount,
                let gridItem = spanPreference.item
            else {
                continue
            } // TODO: Reduce span
            
            while occupiedPoints.contains(lastPoint, rowSpan: spanPreference.span.row, columnSpan: spanPreference.span.column)
                || lastPoint.column + spanPreference.span.column > columnsCount {
                    lastPoint = lastPoint.nextPoint(columnsCount: columnsCount)
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
            rowsCount = max(rowsCount, arrangedItem.endPoint.row + 1)
            result.append(arrangedItem)
            lastPoint = lastPoint.nextPoint(columnsCount: columnsCount)
        }
        
        return LayoutArrangement(columnsCount: columnsCount, rowsCount: rowsCount, items: result)
    }
    
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode) -> PositionsPreference {
        var newPositions: [PositionedItem] = []
        var rowSizes: [CGFloat] = .init(repeating: 0, count: arrangement.rowsCount)
        if case .scroll = contentMode {
            // Calculate sizes of rows
            for positionedItem in position.items {
                guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
                
                let itemSelfHeight = positionedItem.bounds.height
                for index in arrangedItem.startPoint.row...arrangedItem.endPoint.row {
                    rowSizes[index] = max(rowSizes[index], itemSelfHeight / CGFloat(arrangedItem.rowsCount))
                }
            }
        }
 
        for positionedItem in position.items {
            guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
            let rowSize = boundingSize.height / CGFloat(arrangement.rowsCount)
            
            let itemHeight: CGFloat
            let positionY: CGFloat
            
            // TODO: Handle spacing
            switch contentMode {
            case .fill:
                itemHeight = rowSize * CGFloat(arrangedItem.rowsCount)
                positionY = rowSize * CGFloat(arrangedItem.startPoint.row)
            case .scroll:
                itemHeight = (arrangedItem.startPoint.row...arrangedItem.endPoint.row).reduce(0, { result, row in
                    return result + rowSizes[row]
                })
                let centringYCorrection = (itemHeight - positionedItem.bounds.height) / 2
                positionY = (0..<arrangedItem.startPoint.row).reduce(0, { result, row in
                    return result + rowSizes[row]
                }) + centringYCorrection
            }
            
            let trackRange = arrangedItem.startPoint.column...arrangedItem.endPoint.column
            let track = tracks.trackPosition(in: trackRange, length: boundingSize.width)
            
            let newBounds = CGRect(x: track.start, y: positionY, width: track.size, height: itemHeight)
            newPositions.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
        }
        
        let totalHeight = rowSizes.reduce(0, { result, trackSize in
            return result + trackSize
        })

        return PositionsPreference(items: newPositions, size: CGSize(width: boundingSize.width, height: totalHeight))
    }
}

extension GridPoint {
    fileprivate func nextPoint(columnsCount: Int) -> GridPoint {
        var column = self.column
        var row = self.row
        
        column += 1
        if column >= columnsCount {
            column = 0
            row += 1
        }
        
        return GridPoint(row: row, column: column)
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

extension Array where Element == TrackSize {
    fileprivate func trackPosition(in range: ClosedRange<Int>, length: CGFloat) -> (start: CGFloat, size: CGFloat) {
        var result = (fractionCount: 0, upcomingFractions: 0, totalConsts: 0, upcomingConsts: 0)
        result = self.enumerated().reduce(result) { result, item in
            var fractionCount = result.fractionCount
            var upcomingFractions = result.upcomingFractions
            var upcomingConsts = result.upcomingConsts
            var totalConsts = result.totalConsts
            
            switch item.element {
            case .fr(let fraction):
                fractionCount += fraction
                if range.lowerBound > item.offset {
                    upcomingFractions += fraction
                }
            case .const(let constLength):
                totalConsts += constLength
                if range.lowerBound > item.offset {
                    upcomingConsts += constLength
                }
            }

            return (fractionCount: fractionCount,
                    upcomingFractions: upcomingFractions,
                    totalConsts: totalConsts,
                    upcomingConsts: upcomingConsts)
        }
        
        let correctedLength = length - CGFloat(result.totalConsts)
        let fractionSize = correctedLength / CGFloat(result.fractionCount)
        let trackStart = CGFloat(result.upcomingFractions) * fractionSize + CGFloat(result.upcomingConsts)
        let trackSize: CGFloat = range.reduce(0) { trackSize, index in
            switch self[index] {
            case .fr(let fraction):
                return trackSize + CGFloat(fraction) * fractionSize
            case .const(let constLength):
                return trackSize + CGFloat(constLength)
            }
        }
        
        return (start: trackStart, size: trackSize)
    }
}
