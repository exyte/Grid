//
//  Constants.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 19.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Constants {
    public static let defaultColumnSpan = 1
    public static let defaultRowSpan = 1
    public static let defaultSpacing: GridSpacing = 5.0
    public static let defaultFractionSize = 1.0 as CGFloat
    public static let defaultContentMode: GridContentMode = .fill
    public static let defaultFlow: GridFlow = .rows
    public static let defaultPacking: GridPacking = .sparse
    public static let defaultCacheMode: GridCacheMode = .inMemoryCache
}
