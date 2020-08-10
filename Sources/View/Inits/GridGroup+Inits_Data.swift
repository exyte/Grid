//
//  GridGroup+Inits_Data.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension GridGroup {
    public init<Data, ID>(_ data: Data, id: KeyPath<Data.Element, ID>, @AnyViewBuilder item: @escaping (Data.Element) -> ConstructionItem) where Data: RandomAccessCollection, ID: Hashable {
        self.contentViews = data.enumerated().flatMap { (dataIndex: Int, dataElement: Data.Element) -> [IdentifiedView] in
            let constructionItem = item(dataElement)
            let views: [IdentifiedView] = constructionItem.contentViews.enumerated().map {
                var identifiedView = $0.element
                if identifiedView.hash == nil {
                    identifiedView.hash =
                        AnyHashable([AnyHashable(dataElement[keyPath: id]),
                                     AnyHashable(id),
                                     AnyHashable(dataIndex + $0.offset)])
                }
                return identifiedView
            }
            return views
        }
    }

    public init(_ data: Range<Int>, @AnyViewBuilder item: @escaping (Int) -> ConstructionItem) {
        self.contentViews = data.flatMap { item($0).contentViews }
    }

    public init<Data>(_ data: Data, @AnyViewBuilder item: @escaping (Data.Element) -> ConstructionItem) where Data: RandomAccessCollection, Data.Element: Identifiable {
        self.contentViews = data.enumerated().flatMap { (dataIndex: Int, dataElement: Data.Element) -> [IdentifiedView] in
            let constructionItem = item(dataElement)
            let views: [IdentifiedView] = constructionItem.contentViews.enumerated().map {
                var identifiedView = $0.element
                if identifiedView.hash == nil {
                    identifiedView.hash =
                        AnyHashable([AnyHashable(dataElement.id),
                                     AnyHashable(dataIndex + $0.offset)])
                }
                return identifiedView
            }
            return views
        }
    }
}
