//
//  CompositePreference.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 22.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct ArrangingPreference: Equatable {
    var gridItems: [GridItem]
    var starts: StartPreference
    var spans: SpanPreference
    var tracks: [GridTrack]
    var flow: GridFlow
    var packing: GridPacking
}

struct ArrangingPreferenceKey: PreferenceKey {
    static var defaultValue: ArrangingPreference?

    static func reduce(value: inout ArrangingPreference?, nextValue: () -> ArrangingPreference?) {
        
        if let nextValue = nextValue() {
            value = nextValue
        }
    }
}
