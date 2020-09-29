//
//  GridElement+asGridElements.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension Array where Element == IdentifiedView {
    func asGridElements<T: Hashable>(index: inout Int, baseHash: T) -> [GridElement] {
        let containerItems: [GridElement] =
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
                    return GridElement($0.element.view, id: gridHash)
        }
        return containerItems
    }

    func asGridElements(index: inout Int) -> [GridElement] {
        let containerItems: [GridElement]  =
            self
                .map {
                    let gridHash: AnyHashable
                    if let viewHash = $0.hash {
                        gridHash = viewHash
                    } else {
                        gridHash = AnyHashable(index)
                        index += 1
                    }
                    return GridElement($0.view, id: gridHash)

                }
        return containerItems
    }
}

extension View {
    func extractContentViews() -> [IdentifiedView] {
        if let container = self as? GridForEachRangeInt {
            return container.contentViews
        } else if let container = self as? GridForEachIdentifiable {
            return container.contentViews
        } else if let container = self as? GridForEachID {
            return container.contentViews
        } else if let container = self as? GridGroupContaining {
            return container.contentViews
        } else if let container = self as? ConstructionItem {
            return container.contentViews
        }
        return [IdentifiedView(hash: nil, view: AnyView(self))]
    }
}
