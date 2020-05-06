//
//  GridIndex.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

struct GridIndex: Equatable {
    var column: Int
    var row: Int
    
    static let zero = GridIndex(column: 0, row: 0)
}
