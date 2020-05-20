//
//  SpanPreference.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 18.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct GridOverlayPreference: GridCellPreference {
    var content: (_ rect: CGSize) -> AnyView
}

struct GridOverlayPreferenceKey: PreferenceKey {
    typealias Value = GridOverlayPreference
    
    static var defaultValue = GridOverlayPreference(content: { _ in AnyView(EmptyView())})

    static func reduce(value: inout GridOverlayPreference, nextValue: () -> GridOverlayPreference) {
        value = nextValue()
    }
}
