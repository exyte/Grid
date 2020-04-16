//
//  LayoutArrangement+sss.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

extension LayoutArrangement: CustomStringConvertible {
    var description: String {
        var iterations = 0
        var result = ""
        let maxRow = self.items.map(\.endPosition.row).max(by: <) ?? 0
        
        var items = self.items.map { (arrangement: $0, square: $0.area) }

        for row in 0...maxRow {
            columnsCycle: for column in 0..<self.columnsCount {
                for (index, item) in items.enumerated() {
                    iterations += 1
                    if item.arrangement.contains(GridPosition(row: row, column: column)) {
                        result += item.arrangement.gridItem.tag ?? "-"
                        items[index].square -= 1
                        if items[index].square == 0 {
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
