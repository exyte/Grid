//
//  ArrangedItem.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

/// Result position of grid item.  Specfies the abstract position in grid view
struct ArrangedItem: Equatable {
    let gridItem: GridItem
    let startPosition: GridPosition
    let endPosition: GridPosition
    
    func contains(_ position: GridPosition) -> Bool {
        return position.column >= startPosition.column
            && position.column <= endPosition.column
            && position.row >= startPosition.row
            && position.row <= endPosition.row
    }
    
    var area: Int {
        return self.rowsCount * self.rowsCount
    }
    
    var columnsCount: Int { endPosition.column - startPosition.column + 1 }
    
    var rowsCount: Int { endPosition.row - startPosition.row + 1 }
}
