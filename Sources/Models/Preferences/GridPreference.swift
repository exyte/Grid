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
        var span: GridSpan?
        var start: GridStart?
        
        static let empty = ItemInfo()
    }
    
    struct Environment: Equatable {
        var tracks: [GridTrack]
        var contentMode: GridContentMode
        var flow: GridFlow
        var packing: GridPacking
        var boundingSize: CGSize
    }

    var itemsInfo: [ItemInfo] = []
    var environment: Environment?

    static let `default` = GridPreference(itemsInfo: [])
}

struct GridPreferenceKey: PreferenceKey {
    static var defaultValue = GridPreference.default

    static func reduce(value: inout GridPreference, nextValue: () -> GridPreference) {
        value = GridPreference(itemsInfo: value.itemsInfo + nextValue().itemsInfo,
                               environment: nextValue().environment ?? value.environment)
    }
}

extension Array where Element == GridPreference.ItemInfo {
    var mergedToSingleValue: Self {
        let positionedItem = self.compactMap(\.positionedItem).first
        let span = self.compactMap(\.span).first ?? .default
        let start = self.compactMap(\.start).first ?? .default
        let itemInfo = GridPreference.ItemInfo(positionedItem: positionedItem,
                                               span: span,
                                               start: start)
        return [itemInfo]
    }
    
    var asArrangementInfo: [ArrangementInfo] {
        return self.compactMap {
            guard
                let gridItem = $0.positionedItem?.gridItem,
                let start = $0.start,
                let span = $0.span
            else {
                return nil
            }
            return ArrangementInfo(gridItem: gridItem,
                                   start: start,
                                   span: span)
        }
    }
}
