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
        let containerItems =
            self.extractContentViews()
                .enumerated()
                .map { GridItem($0.element, id: AnyHashable($0.offset + index)) }
        index += containerItems.count
        return containerItems
    }
    
    private func extractContentViews() -> [AnyView] {
        var contentViews: [AnyView] = []
        var isContainer = true
        
        if let container = self as? GridForEachRangeInt {
            contentViews = container.contentViews
        } else if let container = self as? GridForEachIdentifiable {
            contentViews = container.contentViews
        } else if let container = self as? GridForEachID {
            contentViews = container.contentViews
        } else if let container = self as? GridGroupContaining {
            contentViews = container.contentViews
        } else {
            isContainer = false
        }
        
        if isContainer {
            contentViews = contentViews.flatMap {
                $0.extractContentViews()
            }
        } else {
            contentViews = [AnyView(self)]
        }
        return contentViews
    }
}
