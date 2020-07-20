//
//  GridContentMode.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 24.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

/// Grid behaviour inside its parent
public enum GridContentMode {
    /// Scrolls inside parent container.
    /// Each item in the grid flow direction has .fit implicit size.
    case scroll
    
    /// Resizes content views to fill parent container.
    /// Each item in the grid flow direction has .fr(1) implicit size.
    case fill
    
    /// The grid has a fixed size in the grid flow direction that equals its intrinsic size.
    /// Each item in the grid flow direction has .fit implicit size.
    /// Could be used if Grid is placed into ScrollView which axis is equal to the grid flow direction.
    case intrinsic
}
