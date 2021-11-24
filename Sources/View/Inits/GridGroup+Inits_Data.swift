//
//  GridGroup+Inits_Data.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension GridGroup {
  public init<Data, ID>(_ data: Data, id: KeyPath<Data.Element, ID>, @GridBuilder item: @escaping (Data.Element) -> GridBuilderResult) where Data: RandomAccessCollection, ID: Hashable {
    self.contentViews = data.enumerated().flatMap { (_, dataElement: Data.Element) -> [GridElement] in
      let constructionItem = item(dataElement)
      let views: [GridElement] = constructionItem.contentViews.enumerated().map {
        var gridElement = $0.element
        if let identifiedHash = gridElement.id {
          gridElement.id =
            AnyHashable([identifiedHash,
                         AnyHashable(dataElement[keyPath: id]),
                         AnyHashable(id)])
        } else {
          gridElement.id =
            AnyHashable([AnyHashable(dataElement[keyPath: id]),
                         AnyHashable(id),
                         AnyHashable($0.offset)])
        }
        return gridElement
      }
      return views
    }
  }

  public init(_ data: Range<Int>, @GridBuilder item: @escaping (Int) -> GridBuilderResult) {
    self.contentViews = data.flatMap { item($0).contentViews }
  }

  public init<Data>(_ data: Data, @GridBuilder item: @escaping (Data.Element) -> GridBuilderResult) where Data: RandomAccessCollection, Data.Element: Identifiable {
    self.contentViews = data.enumerated().flatMap { (_, dataElement: Data.Element) -> [GridElement] in
      let constructionItem = item(dataElement)
      let views: [GridElement] = constructionItem.contentViews.enumerated().map {
        var gridElement = $0.element
        if let identifiedHash = gridElement.id {
          gridElement.id =
            AnyHashable([identifiedHash,
                         dataElement.id])
        } else {
          gridElement.id =
            AnyHashable([AnyHashable(dataElement.id),
                         AnyHashable($0.offset)])
        }
        return gridElement
      }
      return views
    }
  }

  public init<Data: Identifiable>(_ data: Data, @GridBuilder item: @escaping (Data) -> GridBuilderResult) {
    self.init([data], item: item)
  }

  public init<Data: Hashable>(_ data: Data, @GridBuilder item: @escaping (Data) -> GridBuilderResult) {
    self.init([data], id: \.self, item: item)
  }
}
