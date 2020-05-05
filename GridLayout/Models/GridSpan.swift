//
//  GridSpan.swift
//  GridLayout
//
//  Created by Denis Obukhov on 19.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

struct GridSpan: GridPointing, Equatable {
    var row: Int = Constants.defaultRowSpan
    var column: Int = Constants.defaultColumnSpan
    
    static let `default` = GridSpan()
}
