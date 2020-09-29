//
//  GridGroup+Inits_Data.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension GridGroup {
    public init<Data, ID>(_ data: Data, id: KeyPath<Data.Element, ID>, @GridBuilder item: @escaping (Data.Element) -> ConstructionItem) where Data: RandomAccessCollection, ID: Hashable {
        self.contentViews = data.enumerated().flatMap { (_, dataElement: Data.Element) -> [IdentifiedView] in
            let constructionItem = item(dataElement)
            let views: [IdentifiedView] = constructionItem.contentViews.enumerated().map {
                var identifiedView = $0.element
                if let identifiedHash = identifiedView.hash {
                    identifiedView.hash =
                        AnyHashable([identifiedHash,
                                     AnyHashable(dataElement[keyPath: id]),
                                     AnyHashable(id)])
                } else {
                    identifiedView.hash =
                        AnyHashable([AnyHashable(dataElement[keyPath: id]),
                                     AnyHashable(id),
                                     AnyHashable($0.offset)])
                }
                return identifiedView
            }
            return views
        }
    }

    public init(_ data: Range<Int>, @GridBuilder item: @escaping (Int) -> ConstructionItem) {
        self.contentViews = data.flatMap { item($0).contentViews }
    }

    public init<Data>(_ data: Data, @GridBuilder item: @escaping (Data.Element) -> ConstructionItem) where Data: RandomAccessCollection, Data.Element: Identifiable {
        self.contentViews = data.enumerated().flatMap { (_, dataElement: Data.Element) -> [IdentifiedView] in
            let constructionItem = item(dataElement)
            let views: [IdentifiedView] = constructionItem.contentViews.enumerated().map {
                var identifiedView = $0.element
                if let identifiedHash = identifiedView.hash {
                    identifiedView.hash =
                        AnyHashable([identifiedHash,
                                    dataElement.id])
                } else {
                    identifiedView.hash =
                        AnyHashable([AnyHashable(dataElement.id),
                                     AnyHashable($0.offset)])
                }
                return identifiedView
            }
            return views
        }
    }

    public init<Data: Identifiable>(_ data: Data, @GridBuilder item: @escaping (Data) -> ConstructionItem) {
        self.init([data], item: item)
    }

    public init<Data: Hashable>(_ data: Data, @GridBuilder item: @escaping (Data) -> ConstructionItem) {
        self.init([data], id: \.self, item: item)
    }
}
