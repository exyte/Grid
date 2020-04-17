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
    func arrange(items: [GridArrangeable], columnsCount: Int) -> LayoutArrangement
}

class LayoutArrangerImpl: LayoutArranger {
    
    func arrange(items: [GridArrangeable], columnsCount: Int) -> LayoutArrangement {
        guard columnsCount > 0 else { return LayoutArrangement(columnsCount: columnsCount, items: []) }
            
        var result: [ArrangedItem] = []
        var occupiedPositions: [GridPosition] = []
        
        var lastPosition = GridPosition(row: 0, column: 0)
        
        for item in items {
            guard item.columnSpan <= columnsCount else { continue } // TODO: Reduce span
            
            while occupiedPositions.contains(lastPosition, rowSpan: item.rowSpan, columnSpan: item.columnSpan)
                || lastPosition.column + item.columnSpan > columnsCount {
                    lastPosition = lastPosition.nextPosition(columnsCount: columnsCount)
            }

            for row in lastPosition.row..<lastPosition.row + item.rowSpan {
                for column in lastPosition.column..<lastPosition.column + item.columnSpan {
                    occupiedPositions.append(GridPosition(row: row, column: column))
                }
            }
            
            let startPosition = lastPosition
            let endPosition = GridPosition(row: startPosition.row + item.rowSpan - 1,
                                           column: startPosition.column + item.columnSpan - 1)

            result.append(ArrangedItem(gridItem: item, startPosition: startPosition, endPosition: endPosition))
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
