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
    func reposition(_ items: [PositionedItem], arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize]) -> [PositionedItem]
}

class LayoutArrangerImpl: LayoutArranger {
    
    func arrange(spanPreferences: [SpanPreference], columnsCount: Int) -> LayoutArrangement {
        guard columnsCount > 0 else { return LayoutArrangement(columnsCount: columnsCount, rowsCount: 0, items: []) }
            
        var result: [ArrangedItem] = []
        var occupiedPositions: [GridPosition] = []
        
        var lastPosition: GridPosition = .zero
        var rowsCount = 0

        for spanPreference in spanPreferences {
            guard
                spanPreference.span.column <= columnsCount,
                let gridItem = spanPreference.item
            else {
                continue
            } // TODO: Reduce span
            
            while occupiedPositions.contains(lastPosition, rowSpan: spanPreference.span.row, columnSpan: spanPreference.span.column)
                || lastPosition.column + spanPreference.span.column > columnsCount {
                    lastPosition = lastPosition.nextPosition(columnsCount: columnsCount)
            }

            for row in lastPosition.row..<lastPosition.row + spanPreference.span.row {
                for column in lastPosition.column..<lastPosition.column + spanPreference.span.column {
                    occupiedPositions.append(GridPosition(row: row, column: column))
                }
            }
            
            let startPosition = lastPosition
            let endPosition = GridPosition(row: startPosition.row + spanPreference.span.row - 1,
                                           column: startPosition.column + spanPreference.span.column - 1)

            let arrangedItem = ArrangedItem(gridItem: gridItem, startPosition: startPosition, endPosition: endPosition)
            rowsCount = max(rowsCount, arrangedItem.endPosition.row + 1)
            result.append(arrangedItem)
            lastPosition = lastPosition.nextPosition(columnsCount: columnsCount)
        }
        
        return LayoutArrangement(columnsCount: columnsCount, rowsCount: rowsCount, items: result)
    }
    
    func reposition(_ items: [PositionedItem], arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize]) -> [PositionedItem] {
        var newPositions: [PositionedItem] = []
        
        for positionedItem in items {
            guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
            let rowSize = boundingSize.height / CGFloat(arrangement.rowsCount)
            let itemHeight = rowSize * CGFloat(arrangedItem.rowsCount)
            let trackRange = arrangedItem.startPosition.column...arrangedItem.endPosition.column
            let track = tracks.trackPosition(in: trackRange, length: boundingSize.width)
            let positionY = rowSize * CGFloat(arrangedItem.startPosition.row)
            let newBounds = CGRect(x: track.start, y: positionY, width: track.size, height: itemHeight)
            newPositions.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
        }
        
        return newPositions
    }
}

extension GridPosition {
    fileprivate func nextPosition(columnsCount: Int) -> GridPosition {
        var column = self.column
        var row = self.row
        
        column += 1
        if column >= columnsCount {
            column = 0
            row += 1
        }
        
        return GridPosition(row: row, column: column)
    }
}

extension Array where Element == GridPosition {
    fileprivate func contains(_ startPosition: GridPosition, rowSpan: Int, columnSpan: Int) -> Bool {
        for row in startPosition.row..<startPosition.row + rowSpan {
            for column in startPosition.column..<startPosition.column + columnSpan {
                if self.contains(GridPosition(row: row, column: column)) {
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
