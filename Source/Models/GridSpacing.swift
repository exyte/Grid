//
//  GridSpacing.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 14.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import CoreGraphics

public struct GridSpacing: Hashable {
    let horizontal: CGFloat
    let vertical: CGFloat
    static let zero = GridSpacing(horizontal: 0, vertical: 0)
    
    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

extension GridSpacing: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = Self.init(horizontal: CGFloat(value), vertical: CGFloat(value))
    }
}

extension GridSpacing: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = Self.init(horizontal: CGFloat(value), vertical: CGFloat(value))
    }
}

extension GridSpacing: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count <= 2)
        var vertical: CGFloat = 0
        var horizontal: CGFloat = 0
        
        if elements.count > 1 {
            horizontal = elements[0]
            vertical = elements[1]
        } else if elements.count == 1 {
            vertical = elements[0]
            horizontal = elements[0]
        }

        self = Self.init(horizontal: horizontal, vertical: vertical)
    }
}

extension GridSpacing: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .zero
    }
}
