//
//  LayoutArrangement.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import CoreGraphics

/// Encapsulates the arranged items and total columns and rows count of a grid view
struct LayoutArrangement: Equatable, Hashable {
    var columnsCount: Int
    var rowsCount: Int
    let items: [ArrangedItem]
    
    static var zero = LayoutArrangement(columnsCount: 0, rowsCount: 0, items: [])
    
    subscript(gridItem: GridItem) -> ArrangedItem? {
        items.first(where: { $0.gridItem == gridItem })
    }
}
