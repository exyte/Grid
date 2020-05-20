//
//  StartPreference.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct StartPreference: Equatable, GridItemContaining {
    var item: GridItem?
    var start = GridStart.default

    static let `default` = StartPreference()
}

struct StartPreferenceKey: PreferenceKey {
    static var defaultValue = [StartPreference()]

    static func reduce(value: inout [StartPreference], nextValue: () -> [StartPreference]) {
        value.append(contentsOf: nextValue())
    }
}
