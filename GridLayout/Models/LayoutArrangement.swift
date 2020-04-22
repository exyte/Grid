//
//  LayoutArrangement.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import CoreGraphics

/// Encapsulates the arranged items and total columns and rows count of a grid view
struct LayoutArrangement {
    let columnsCount: Int
    let rowsCount: Int
    let items: [ArrangedItem]
    
    subscript(gridItem: GridItem) -> ArrangedItem? {
        items.first(where: { $0.gridItem == gridItem })
    }
}
