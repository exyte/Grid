//
//  GridPreference.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 16.07.2020.
//

import SwiftUI

struct GridPreference: Equatable {
    struct ItemInfo: Equatable {
        var positionedItem: PositionedItem?
        var bounds: CGRect?
        var span: GridSpan?
        var start: GridStart?
        
        static let empty = ItemInfo()
    }
    
    struct Environment: Equatable {
        var tracks: [GridTrack]
        var contentMode: GridContentMode
        var flow: GridFlow
        var packing: GridPacking
    }

    var itemsInfo: [ItemInfo] = []
    var environment: Environment?

    static let `default` = GridPreference(itemsInfo: [])
    
    subscript(gridItem: GridItem) -> PositionedItem? {
        itemsInfo.compactMap(\.positionedItem).first(where: { $0.gridItem == gridItem })
    }
    
    subscript(arrangedItem: ArrangedItem) -> PositionedItem? {
        itemsInfo.compactMap(\.positionedItem).first(where: { $0.gridItem == arrangedItem.gridItem })
    }
}

struct GridPreferenceKey: PreferenceKey {
    static var defaultValue = GridPreference.default

    static func reduce(value: inout GridPreference, nextValue: () -> GridPreference) {
        value = GridPreference(itemsInfo: value.itemsInfo + nextValue().itemsInfo,
                               environment: nextValue().environment ?? value.environment)
    }
}
