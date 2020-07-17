//
//  View+GridPreferences.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 28.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension View {
    public func gridSpan(column: Int = Constants.defaultColumnSpan,
                         row: Int = Constants.defaultRowSpan
    ) -> some View {
        transformPreference(GridPreferenceKey.self, { preferences in
            var info = preferences.itemsInfo.first ?? .empty
            info.span = GridSpan(column: max(column, 1), row: max(row, 1))
            preferences.itemsInfo = [info]
        })
    }
    
    public func gridSpan(_ span: GridSpan) -> some View {
        transformPreference(GridPreferenceKey.self, { preferences in
            var info = preferences.itemsInfo.first ?? .empty
            info.span = GridSpan(column: max(span.column, 1), row: max(span.row, 1))
            preferences.itemsInfo = [info]
        })
    }
    
    public func gridStart(column: Int? = nil, row: Int? = nil) -> some View {
        transformPreference(GridPreferenceKey.self, { preferences in
            var info = preferences.itemsInfo.first ?? .empty
            info.start = GridStart(column: column.nilIfBelowZero, row: row.nilIfBelowZero)
            preferences.itemsInfo = [info]
        })
    }
    
    public func gridStart(_ start: GridStart) -> some View {
        transformPreference(GridPreferenceKey.self, { preferences in
            var info = preferences.itemsInfo.first ?? .empty
            info.start = GridStart(column: start.column.nilIfBelowZero, row: start.row.nilIfBelowZero)
            preferences.itemsInfo = [info]
        })
    }
    
    public func gridCellOverlay<Content: View>(
        @ViewBuilder content: @escaping (CGSize?) -> Content
    ) -> some View {
        preference(
            key: GridOverlayPreferenceKey.self,
            value: GridOverlayPreference { rect in
                AnyView(content(rect))
            }
        )
    }
    
    public func gridCellBackground<Content: View>(
        @ViewBuilder content: @escaping (CGSize?) -> Content
    ) -> some View {
        preference(
            key: GridBackgroundPreferenceKey.self,
            value: GridBackgroundPreference { rect in
                AnyView(content(rect))
        })
    }
}

extension Optional where Wrapped == Int {
    var nilIfBelowZero: Wrapped? {
        let correctedValue: Int?
        switch self {
        case .none:
            correctedValue = nil
        case .some(let value):
            correctedValue = value >= 0 ? value : nil
        }
        return correctedValue
    }
}
