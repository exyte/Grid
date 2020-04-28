//
//  SpanPreference.swift
//  GridLayout
//
//  Created by Denis Obukhov on 18.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct GridBackgroundPreference {
    var content: (_ rect: CGRect?) -> AnyView
}

struct GridBackgroundPreferenceKey: PreferenceKey {
    typealias Value = GridBackgroundPreference
    
    static var defaultValue = GridBackgroundPreference(content: { _ in AnyView(EmptyView())})

    static func reduce(value: inout GridBackgroundPreference, nextValue: () -> GridBackgroundPreference) {
        value = nextValue()
    }
}
