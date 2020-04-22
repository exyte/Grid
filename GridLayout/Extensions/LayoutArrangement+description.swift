//
//  LayoutArrangement+description.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

extension LayoutArrangement: CustomStringConvertible {
    var description: String {
        var result = ""

        var items = self.items.map { (arrangement: $0, area: $0.area) }

        for row in 0...self.rowsCount {
            columnsCycle: for column in 0..<self.columnsCount {
                for (index, item) in items.enumerated() {
                    if item.arrangement.contains(GridPoint(row: row, column: column)) {
                        result += String(item.arrangement.gridItem.debugID.uuidString.prefix(1))
                        items[index].area -= 1
                        if items[index].area == 0 {
                            items.remove(at: index)
                        }
                        continue columnsCycle
                    }
                }
                result += "."
            }
            result += "\n"
        }
        
        return result
    }
}
