//
//  SpanPreference.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 18.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct SpanPreference: Equatable {
    struct Element: Equatable {
        var gridItem: GridItem?
        var span = GridSpan.default
    }
    
    var items: [Element]
}

struct SpansPreferenceKey: PreferenceKey {
    static var defaultValue: SpanPreference?

    static func reduce(value: inout SpanPreference?, nextValue: () -> SpanPreference?) {
        if let nextValue = nextValue() {
            value = SpanPreference(items: (value?.items ?? []) + nextValue.items)
        }
    }
}
