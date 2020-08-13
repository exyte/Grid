//
//  GridPreference.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 16.07.2020.
//

import SwiftUI

public struct IDPair: Hashable {
    var originID: AnyHashable?
    var newID: AnyHashable?
}

struct GridPreference: Equatable {
    struct ItemInfo: Equatable {
        var positionedItem: PositionedItem?
        var span: GridSpan?
        var start: GridStart?
        var idPair: IDPair?
        
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
    var overriddenIDs = Set<IDPair>()

    static let `default` = GridPreference(itemsInfo: [])
}

struct GridPreferenceKey: PreferenceKey {
    static var defaultValue = GridPreference.default

    static func reduce(value: inout GridPreference, nextValue: () -> GridPreference) {
        var newIDs = value.overriddenIDs.union(nextValue().overriddenIDs)
        newIDs = newIDs.union(Set(value.itemsInfo.compactMap(\.idPair).filter { $0.newID != nil && $0.originID != nil }))
        newIDs = newIDs.union(Set(nextValue().itemsInfo.compactMap(\.idPair).filter { $0.newID != nil && $0.originID != nil }))
        value = GridPreference(itemsInfo: value.itemsInfo + nextValue().itemsInfo,
                               environment: nextValue().environment ?? value.environment,
                               overriddenIDs: newIDs)
    }
}

extension Array where Element == GridPreference.ItemInfo {
    var mergedToSingleValue: Self.Element {
        let positionedItem = self.compactMap(\.positionedItem).first
        let span = self.compactMap(\.span).first ?? .default
        let start = self.compactMap(\.start).first ?? .default
        let idPair = self.compactMap(\.idPair).first
        let itemInfo = GridPreference.ItemInfo(positionedItem: positionedItem,
                                               span: span,
                                               start: start,
                                               idPair: idPair)
        return itemInfo
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
