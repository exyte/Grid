//
//  GridStart.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 19.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import Foundation

public struct GridStart: Equatable, Hashable {
    var column: Int?
    var row: Int?
    
    static let `default` = GridStart(column: nil, row: nil)
}

extension GridStart: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Int?...) {
        assert(elements.count == 2)
        self = GridStart(column: elements[0], row: elements[1])
    }
}

extension GridStart: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .default
    }
}
