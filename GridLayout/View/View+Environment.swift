//
//  View+Environment.swift
//  GridLayout
//
//  Created by Denis Obukhov on 24.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

// MARK: GridContentMode
extension View {
    public func gridContentMode(_ contentMode: GridContentMode) -> some View {
        return self.environment(\.contentMode, contentMode)
    }
    
    public func gridFlow(_ flow: GridFlow) -> some View {
        return self.environment(\.flow, flow)
    }
}

extension EnvironmentValues {
    var contentMode: GridContentMode {
        get { self[EnvironmentKeys.ContentMode.self] }
        set { self[EnvironmentKeys.ContentMode.self] = newValue }
    }
    
    var flow: GridFlow {
        get { self[EnvironmentKeys.Flow.self] }
        set { self[EnvironmentKeys.Flow.self] = newValue }
    }
}

struct EnvironmentKeys {
    struct ContentMode: EnvironmentKey {
        static let defaultValue = GridContentMode.fill
    }

    struct Flow: EnvironmentKey {
        static let defaultValue = GridFlow.columns
    }
}
