//
//  View+GridPreferences.swift
//  GridLayout
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
            value: [SpanPreference(span: GridSpan(row: row,
                                                  column: column))])
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
