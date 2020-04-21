//
//  GridItem.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

public struct GridItem: Identifiable {
    public let id: AnyHashable
    public let view: AnyView
    public var tag: String?
    let debugID = UUID()
    
    public init<T: View>(_ view: T, id: AnyHashable) {
        self.view = AnyView(view)
        self.id = id
    }
    
    public init<T: View>(_ view: T, id: AnyHashable, tag: String?) {
        self.init(view, id: id)
        self.tag = tag
    }
}

extension GridItem: Equatable {
    public static func == (lhs: GridItem,
                           rhs: GridItem) -> Bool {
        return lhs.id == rhs.id
    }
}
