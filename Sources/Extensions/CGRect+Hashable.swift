//
//  CGRect+Hashable.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 14.08.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import CoreGraphics

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(minX)
        hasher.combine(minY)
        hasher.combine(maxX)
        hasher.combine(maxY)
    }
}
