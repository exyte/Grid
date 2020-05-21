//
//  StartPreference.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 14.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct StartPreference: Equatable {
    struct Starts: Equatable {
        var item: GridItem?
        var start = GridStart.default
    }
    
    struct Environment: Equatable {
        var tracks: [GridTrack]
        var flow: GridFlow
        var packing: GridPacking
        var spans: [SpanPreference]
    }
    
    var starts: [Starts]
    var environment: Environment?
}

struct StartPreferenceKey: PreferenceKey {
    static var defaultValue: StartPreference? = nil

    static func reduce(value: inout StartPreference?, nextValue: () -> StartPreference?) {
        if let nextValue = nextValue() {
            value = StartPreference(starts: (value?.starts ?? []) + nextValue.starts, environment: nextValue.environment)
        }
        
    }
}
