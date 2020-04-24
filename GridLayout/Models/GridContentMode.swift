//
//  GridContentMode.swift
//  GridLayout
//
//  Created by Denis Obukhov on 24.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

/// Grid behaviour inside its parent
public enum GridContentMode {
    /// Scrolls inside parent container
    case scroll(alignment: Alignment)
    
    /// Fills the entire space of the parent container
    case fill
    
    // TODO: Add fit
}
