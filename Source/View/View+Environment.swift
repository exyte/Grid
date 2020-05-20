//
//  View+Environment.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 24.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

// MARK: GridContentMode
extension View {
    public func gridContentMode(_ contentMode: GridContentMode) -> some View {
        return self.environment(\.gridContentMode, contentMode)
    }
    
    public func gridFlow(_ flow: GridFlow) -> some View {
        return self.environment(\.gridFlow, flow)
    }
    
    public func gridPacking(_ packing: GridPacking) -> some View {
        return self.environment(\.gridPacking, packing)
    }
}

extension EnvironmentValues {
    var gridContentMode: GridContentMode {
        get { self[EnvironmentKeys.ContentMode.self] }
        set { self[EnvironmentKeys.ContentMode.self] = newValue }
    }
    
    var gridFlow: GridFlow {
        get { self[EnvironmentKeys.Flow.self] }
        set { self[EnvironmentKeys.Flow.self] = newValue }
    }
    
    var gridPacking: GridPacking {
        get { self[EnvironmentKeys.Packing.self] }
        set { self[EnvironmentKeys.Packing.self] = newValue }
    }
}

struct EnvironmentKeys {
    struct ContentMode: EnvironmentKey {
        static let defaultValue = GridContentMode.fill
    }

    struct Flow: EnvironmentKey {
        static let defaultValue = GridFlow.rows
    }
    
    struct Packing: EnvironmentKey {
        static let defaultValue = GridPacking.sparse
    }
}
