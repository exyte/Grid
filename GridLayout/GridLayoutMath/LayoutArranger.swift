//
//  GridLayoutMath.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

protocol LayoutArranger {
    /// Arranges grid items into layout arrangement that specifies relations between abstract position in grid view and specific item
    /// - Parameters:
    ///   - items: Grid items to arrange. They could specify row and columns spans
    ///   - columnsCount: Total count of columns in grid view
    func arrange(preferences: [SpanPreference], columnsCount: Int) -> LayoutArrangement
}

class LayoutArrangerImpl: LayoutArranger {
    
    func arrange(preferences: [SpanPreference], columnsCount: Int) -> LayoutArrangement {
        guard columnsCount > 0 else { return LayoutArrangement(columnsCount: columnsCount, items: []) }
            
        var result: [ArrangedItem] = []
        var occupiedPositions: [GridPosition] = []
        
        var lastPosition = GridPosition(row: 0, column: 0)
        
        for spanPreference in preferences {
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

            result.append(ArrangedItem(gridItem: gridItem, startPosition: startPosition, endPosition: endPosition))
            lastPosition = lastPosition.nextPosition(columnsCount: columnsCount)
            
        }
        return LayoutArrangement(columnsCount: columnsCount, items: result)
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
