//
//  File.swift
//  GridLayout
//
//  Created by Denis Obukhov on 20.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation
import CoreGraphics

struct PositionedItem: Equatable {
    let bounds: CGRect
    let gridItem: GridItem
}
