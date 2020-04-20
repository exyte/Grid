//
//  SpanPreference.swift
//  GridLayout
//
//  Created by Denis Obukhov on 18.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct SpanPreference: Equatable {
    var item: GridItem?
    var span = GridSpan.default

    static let `default` = SpanPreference()
}

struct SpanPreferenceKey: PreferenceKey {
    static var defaultValue = [SpanPreference()]

    static func reduce(value: inout [SpanPreference], nextValue: () -> [SpanPreference]) {
        value.append(contentsOf: nextValue())
    }
}
