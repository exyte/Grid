//
//  GridItem.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct GridItem: Identifiable {
    let id = UUID()
    let view: AnyView
    var tag: String?
    
    init<T: View>(_ view: T) {
        self.view = AnyView(view)
    }
    
    init<T: View>(_ view: T, tag: String?) {
        self.init(view)
        self.tag = tag
    }
}

extension GridItem: Equatable {
    static func == (lhs: GridItem,
                    rhs: GridItem) -> Bool {
        return lhs.id == rhs.id
    }
}
