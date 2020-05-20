//
//  View+GridPreferences.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 28.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

extension View {
    public func gridSpan(column: Int = Constants.defaultColumnSpan,
                         row: Int = Constants.defaultRowSpan
    ) -> some View {
        preference(
            key: SpansPreferenceKey.self,
            value: [SpanPreference(span: GridSpan(column: column,
                                                  row: row))])
    }
    
    public func gridStart(column: Int? = nil, row: Int? = nil) -> some View {
        preference(
            key: StartPreferenceKey.self,
            value: [StartPreference(start: GridStart(column: column,
                                                     row: row))])
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
