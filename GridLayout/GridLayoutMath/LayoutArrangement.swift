//
//  LayoutArrangement.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

struct LayoutArrangement {
    let columnsCount: Int
    var items: [ArrangedItem]
    
    subscript(gridItem: GridItem) -> ArrangedItem? {
        get {
            items.first(where: { $0.gridItem == gridItem })
        }
    }
}
