//
//  GridItem.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

public struct GridItem: Identifiable {
    public let id = UUID()
    public let view: AnyView
    public var tag: String?
    
    public init<T: View>(_ view: T) {
        self.view = AnyView(view)
    }
    
    public init<T: View>(_ view: T, tag: String?) {
        self.init(view)
        self.tag = tag
    }
}

extension GridItem: Equatable {
    public static func == (lhs: GridItem,
                           rhs: GridItem) -> Bool {
        return lhs.id == rhs.id
    }
}
