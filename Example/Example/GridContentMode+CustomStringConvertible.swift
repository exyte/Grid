//
//  GridContentMode+CustomStringConvertible.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 21.07.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import Foundation
import ExyteGrid

extension GridContentMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .scroll:
            return "Scroll"
        case .fill:
            return "Fill"
        case .intrinsic:
            return "Intrinsic"
        }
    }
}
