//
//  View+Environment.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 24.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

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
    
    public func gridAnimation(_ animation: Animation?) -> some View {
        return self.environment(\.gridAnimation, animation)
    }

    public func gridCache(_ cache: GridCacheMode?) -> some View {
        return self.environment(\.gridCache, cache)
    }
}

extension EnvironmentValues {
    var gridContentMode: GridContentMode? {
        get { self[EnvironmentKeys.ContentMode.self] }
        set { self[EnvironmentKeys.ContentMode.self] = newValue }
    }
    
    var gridFlow: GridFlow? {
        get { self[EnvironmentKeys.Flow.self] }
        set { self[EnvironmentKeys.Flow.self] = newValue }
    }
    
    var gridPacking: GridPacking? {
        get { self[EnvironmentKeys.Packing.self] }
        set { self[EnvironmentKeys.Packing.self] = newValue }
    }
    
    var gridAnimation: Animation? {
        get { self[EnvironmentKeys.GridAnimation.self] }
        set { self[EnvironmentKeys.GridAnimation.self] = newValue }
    }

    var gridCache: GridCacheMode? {
        get { self[EnvironmentKeys.GridCache.self] }
        set { self[EnvironmentKeys.GridCache.self] = newValue }
    }
}

private struct EnvironmentKeys {
    struct ContentMode: EnvironmentKey {
        static let defaultValue: GridContentMode? = nil
    }

    struct Flow: EnvironmentKey {
        static let defaultValue: GridFlow? = nil
    }
    
    struct Packing: EnvironmentKey {
        static let defaultValue: GridPacking? = nil
    }
    
    struct GridAnimation: EnvironmentKey {
        static let defaultValue: Animation? = nil
    }

    struct GridCache: EnvironmentKey {
        static let defaultValue: GridCacheMode? = nil
    }
}
