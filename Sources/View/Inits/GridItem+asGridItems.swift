//
//  GridItem+asGridItems.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension Array where Element == IdentifiedView {
    func  asGridItems<T: Hashable>(index: inout Int, baseHash: T) -> [GridItem] {
        let containerItems: [GridItem] =
            self
                .enumerated()
                .map {
                    let gridHash: AnyHashable
                    if let viewHash = $0.element.hash {
                        gridHash = viewHash
                    } else {
                        gridHash = AnyHashable([baseHash, AnyHashable(index)])
                        index += 1
                    }
                    return GridItem($0.element.view, id: gridHash)
        }
        return containerItems
    }

    func asGridItems(index: inout Int) -> [GridItem] {
        let containerItems: [GridItem]  =
            self
                .map {
                    let gridHash: AnyHashable
                    if let viewHash = $0.hash {
                        gridHash = viewHash
                    } else {
                        gridHash = AnyHashable(index)
                        index += 1
                    }
                    return GridItem($0.view, id: gridHash)

                }
        return containerItems
    }
}

extension View {
    func extractContentViews() -> [IdentifiedView] {
        var contentViews: [IdentifiedView] = []
        var isContainer = true

        if let container = self as? GridForEachRangeInt {
            contentViews = container.contentViews
        } else if let container = self as? GridForEachIdentifiable {
            contentViews = container.contentViews
        } else if let container = self as? GridForEachID {
            contentViews = container.contentViews
        } else if let container = self as? GridGroupContaining {
            return container.contentViews
        } else if let container = self as? ConstructionItem {
            return container.contentViews
        } else {
            isContainer = false
        }

        if isContainer {
            contentViews = contentViews.flatMap {
                $0.view.extractContentViews()
            }
        } else {
            contentViews = [IdentifiedView(hash: nil, view: AnyView(self))]
        }
        return contentViews
    }
}
