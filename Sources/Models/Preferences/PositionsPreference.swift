//
//  PositionPreferece.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 20.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct PositionsPreference: Equatable {
    let items: [PositionedItem]
    let size: CGSize?
    
    struct Environment: Equatable {
        var arrangement: LayoutArrangement
        var boundingSize: CGSize
        var tracks: [GridTrack]
        var contentMode: GridContentMode
        var flow: GridFlow
    }

    var environment: Environment?
    
    static let `default` = PositionsPreference(items: [], size: nil, environment: nil)
    
    subscript(gridItem: GridItem) -> PositionedItem? {
        items.first(where: { $0.gridItem == gridItem })
    }
    
    subscript(arrangedItem: ArrangedItem) -> PositionedItem? {
        items.first(where: { $0.gridItem == arrangedItem.gridItem })
    }
}

struct PositionsPreferenceKey: PreferenceKey {
    static var defaultValue = PositionsPreference.default

    static func reduce(value: inout PositionsPreference, nextValue: () -> PositionsPreference) {
        value = PositionsPreference(items: value.items + nextValue().items, size: value.size, environment: nextValue().environment)
    }
}
