//
//  PositionPreferece.swift
//  GridLayout
//
//  Created by Denis Obukhov on 20.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct PositionPreference: Equatable {
    var items: [PositionedItem]
    
    static let `default` = PositionPreference(items: [])
    
    subscript(gridItem: GridItem) -> PositionedItem? {
        get {
            items.first(where: { $0.gridItem == gridItem })
        }
    }
}

struct PositionPreferenceKey: PreferenceKey {
    
    static var defaultValue = PositionPreference.default

    static func reduce(value: inout PositionPreference, nextValue: () -> PositionPreference) {
        value = PositionPreference(items: value.items + nextValue().items)
    }
}
