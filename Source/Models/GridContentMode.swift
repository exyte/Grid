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
    /// Scrolls inside parent container
    case scroll
    
    /// Fills the entire space of the parent container
    case fill
}
