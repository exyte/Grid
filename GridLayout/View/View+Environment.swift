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
}

extension EnvironmentValues {
    var contentMode: GridContentMode {
        get { self[ContentModeKey.self] }
        set { self[ContentModeKey.self] = newValue }
    }
}

struct ContentModeKey: EnvironmentKey {
    static let defaultValue = GridContentMode.fill
}
