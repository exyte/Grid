//
//  CGSize+Hashable.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 14.08.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import CoreGraphics

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
