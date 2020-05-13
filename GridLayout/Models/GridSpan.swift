//
//  GridSpan.swift
//  GridLayout
//
//  Created by Denis Obukhov on 19.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

struct GridSpan: Equatable {
    var column: Int = Constants.defaultColumnSpan
    var row: Int = Constants.defaultRowSpan
    
    static let `default` = GridSpan()
}

extension GridSpan: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Int...) {
        assert(elements.count == 2)
        self = GridSpan(column: elements[0], row: elements[1])
    }
}
