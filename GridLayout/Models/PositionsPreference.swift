//
//  PositionPreferece.swift
//  GridLayout
//
//  Created by Denis Obukhov on 20.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct PositionsPreference: Equatable {
    var items: [PositionedItem]
    
    static let `default` = PositionsPreference(items: [])
    
    subscript(gridItem: GridItem) -> PositionedItem? {
        items.first(where: { $0.gridItem == gridItem })
    }
}

struct PositionsPreferenceKey: PreferenceKey {
    
    static var defaultValue = PositionsPreference.default

    static func reduce(value: inout PositionsPreference, nextValue: () -> PositionsPreference) {
        value = PositionsPreference(items: value.items + nextValue().items)
    }
}
