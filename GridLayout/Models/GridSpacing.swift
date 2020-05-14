//
//  GridSpacing.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import CoreGraphics

public struct GridSpacing {
    let vertical: CGFloat
    let horizontal: CGFloat
    static let zero = GridSpacing(vertical: 0, horizontal: 0)
}

extension GridSpacing: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = Self.init(vertical: CGFloat(value), horizontal: CGFloat(value))
    }
}

extension GridSpacing: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = Self.init(vertical: CGFloat(value), horizontal: CGFloat(value))
    }
}

extension GridSpacing: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count <= 2)
        var vertical: CGFloat = 0
        var horizontal: CGFloat = 0
        
        if elements.count > 1 {
            vertical = elements[0]
            horizontal = elements[1]
        } else if elements.count == 1 {
            vertical = elements[0]
            horizontal = elements[0]
        }

        self = Self.init(vertical: vertical, horizontal: horizontal)
    }
}

extension GridSpacing: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .zero
    }
}
