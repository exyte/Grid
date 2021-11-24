//
//  GridElement+asGridElements.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension Array where Element == GridElement {
  func asGridElements<T: Hashable>(index: inout Int, baseHash: T?) -> [GridElement] {
    let containerItems: [GridElement] =
      map {
        let gridHash: AnyHashable
        if let viewHash = $0.id {
          gridHash = viewHash
        } else {
          gridHash = AnyHashable([baseHash, AnyHashable(index)])
          index += 1
        }
        return GridElement($0.view, id: gridHash)
      }
    return containerItems
  }

  func asGridElements(index: inout Int) -> [GridElement] {
    asGridElements(index: &index, baseHash: Int?.none)
  }
}

extension View {
  func extractContentViews() -> [GridElement] {
    if let container = self as? GridForEachRangeInt {
      return container.contentViews
    } else if let container = self as? GridForEachIdentifiable {
      return container.contentViews
    } else if let container = self as? GridForEachID {
      return container.contentViews
    } else if let container = self as? GridGroupContaining {
      return container.contentViews
    } else if let container = self as? GridBuilderResult {
      return container.contentViews
    }
    return [GridElement(AnyView(self), id: nil)]
  }
}
