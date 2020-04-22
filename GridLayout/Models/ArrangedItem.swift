//
//  ArrangedItem.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

/// Specfies the abstract position of a grid item in a grid view
struct ArrangedItem {
    let gridItem: GridItem
    let startPoint: GridPoint
    let endPoint: GridPoint
    
    var area: Int { self.rowsCount * self.columnsCount }
    var columnsCount: Int { endPoint.column - startPoint.column + 1 }
    var rowsCount: Int { endPoint.row - startPoint.row + 1 }
    
    func contains(_ point: GridPoint) -> Bool {
        return point.column >= startPoint.column
            && point.column <= endPoint.column
            && point.row >= startPoint.row
            && point.row <= endPoint.row
    }
}
