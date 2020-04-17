//
//  GridItem.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation
import SwiftUI

/// User defined item in grid layout
protocol GridArrangeable {
    var rowSpan: Int { get }
    var columnSpan: Int { get }
    var view: AnyView? { get }
    var tag: String? { get }
    var id: AnyHashable { get }
}

struct EmptyGridItem: GridArrangeable {
    var rowSpan = 0
    var columnSpan = 0
    var view: AnyView?
    var tag: String?
    var id = AnyHashable(UUID())
}

struct GridItem: GridArrangeable {
    var rowSpan = 1
    var columnSpan = 1
    var view: AnyView?
    var tag: String?
    var id = AnyHashable(UUID())
    
    init<Content>(rowSpan: Int = 1, columnSpan: Int = 1, tag: String? = nil, @ViewBuilder content: @escaping () -> Content) where Content: View {
        self.rowSpan = rowSpan
        self.columnSpan = columnSpan
        self.view = AnyView(content())
    }
    
    init(tag: String? = nil, rowSpan: Int = 1, columnSpan: Int = 1) {
        self.rowSpan = rowSpan
        self.columnSpan = columnSpan
        self.view = AnyView(EmptyView())
        self.tag = tag
    }
}
