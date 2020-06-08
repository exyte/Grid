//
//  StartPreference.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 14.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct StartPreference: Equatable {
    struct Element: Equatable {
        var gridItem: GridItem?
        var start = GridStart.default
    }

    var items: [Element]
}

struct StartPreferenceKey: PreferenceKey {
    static var defaultValue: StartPreference?

    static func reduce(value: inout StartPreference?, nextValue: () -> StartPreference?) {
        if let nextValue = nextValue() {
            value = StartPreference(items: (value?.items ?? []) + nextValue.items)
        }
    }
}
