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

extension CGRect {
  func pixelAligned(scale: CGFloat) -> CGRect {
    let x = (origin.x * scale).rounded() / scale
    let y = (origin.y * scale).rounded() / scale
    let maxX = ((origin.x + size.width) * scale).rounded() / scale
    let maxY = ((origin.y + size.height) * scale).rounded() / scale
    return CGRect(x: x, y: y, width: maxX - x, height: maxY - y)
  }
}
