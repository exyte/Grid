//
//  GridStart.swift
//  GridLayout
//
//  Created by Denis Obukhov on 19.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

struct GridStart: Equatable {
    var column: Int?
    var row: Int?
    
    static let `default` = GridStart(column: nil, row: nil)
}

extension GridStart: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Int?...) {
        assert(elements.count == 2)
        self = GridStart(column: elements[0], row: elements[1])
    }
}
