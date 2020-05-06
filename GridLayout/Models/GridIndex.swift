//
//  GridIndex.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

struct GridIndex: Equatable {
    var row: Int
    var column: Int
    
    static let zero = GridIndex(row: 0, column: 0)
}
