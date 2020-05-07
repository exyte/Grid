//
//  GridItem+asGridItems.swift
//  GridLayout
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

extension View {
    func asGridItems(index: inout Int) -> [GridItem] {
        if let container = self as? GridViewsContaining {
            let containerItems =
                container.views
                    .enumerated()
                    .map { GridItem($0.element, id: AnyHashable($0.offset + index)) }
            index += containerItems.count
            return containerItems
        }
        
        let item = GridItem(AnyView(self), id: AnyHashable(index))
        index += 1
        return [item]
    }
}
