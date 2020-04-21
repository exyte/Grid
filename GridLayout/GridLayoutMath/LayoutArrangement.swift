//
//  LayoutArrangement.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import CoreGraphics

struct LayoutArrangement {
    let columnsCount: Int
    let rowsCount: Int
    var items: [ArrangedItem]
    
    subscript(gridItem: GridItem) -> ArrangedItem? {
        items.first(where: { $0.gridItem == gridItem })
    }
}
