//
//  PositionedItem.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 20.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import Foundation
import CoreGraphics

/// Specfies the final position of a grid item in a grid view on the screen
struct PositionedItem: Equatable, Hashable {
    let bounds: CGRect
    let gridItem: GridItem
}
