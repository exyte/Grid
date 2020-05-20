//
//  SpanPreference.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 18.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct GridBackgroundPreference: GridCellPreference {
    var content: (_ rect: CGSize) -> AnyView
}

struct GridBackgroundPreferenceKey: PreferenceKey {
    typealias Value = GridBackgroundPreference
    
    static var defaultValue = GridBackgroundPreference(content: { _ in AnyView(EmptyView())})

    static func reduce(value: inout GridBackgroundPreference, nextValue: () -> GridBackgroundPreference) {
        value = nextValue()
    }
}
