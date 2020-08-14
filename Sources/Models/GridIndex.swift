//
//  GridIndex.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import Foundation

struct GridIndex: Equatable, Hashable {
    var column: Int
    var row: Int
    
    static let zero = GridIndex(column: 0, row: 0)
}

extension GridIndex: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Int...) {
        assert(elements.count == 2)
        self = GridIndex(column: elements[0], row: elements[1])
    }
}
