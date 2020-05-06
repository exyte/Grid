//
//  ArrangedItem.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

/// Specfies the abstract position of a grid item in a grid view
struct ArrangedItem: Equatable {
    let gridItem: GridItem
    let startIndex: GridIndex
    let endIndex: GridIndex
    
    var area: Int { self.rowsCount * self.columnsCount }
    var columnsCount: Int { endIndex.column - startIndex.column + 1 }
    var rowsCount: Int { endIndex.row - startIndex.row + 1 }
    
    func contains(_ index: GridIndex) -> Bool {
        return index.column >= startIndex.column
            && index.column <= endIndex.column
            && index.row >= startIndex.row
            && index.row <= endIndex.row
    }
}
