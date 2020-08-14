//
//  ArrangedItem.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import Foundation

/// Specfies the abstract position of a grid item in a grid view
struct ArrangedItem: Equatable, Hashable {
    let gridItem: GridItem
    let startIndex: GridIndex
    let endIndex: GridIndex
    
    var area: Int { self.rowsCount * self.columnsCount }
    var columnsCount: Int { endIndex.column - startIndex.column + 1 }
    var rowsCount: Int { endIndex.row - startIndex.row + 1 }
    var span: GridSpan { return GridSpan(column: endIndex.column - startIndex.column + 1,
                                         row: endIndex.row - startIndex.row + 1) }
    
    func contains(_ index: GridIndex) -> Bool {
        return index.column >= startIndex.column
            && index.column <= endIndex.column
            && index.row >= startIndex.row
            && index.row <= endIndex.row
    }
}

extension ArrangedItem {
    init(item: GridItem, startIndex: GridIndex, span: GridSpan) {
        let endRow: Int = startIndex.row + span.row - 1
        let endColumn: Int = startIndex.column + span.column - 1
        self = ArrangedItem(gridItem: item, startIndex: startIndex, endIndex: GridIndex(column: endColumn, row: endRow))
    }
}
