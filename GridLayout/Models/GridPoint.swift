//
//  GridPosition.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

struct GridPoint: GridIndexing, Equatable {
    var row: Int
    var column: Int
    
    static let zero = GridPoint(row: 0, column: 0)
}
