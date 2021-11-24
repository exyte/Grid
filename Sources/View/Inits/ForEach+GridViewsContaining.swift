//
//  ForEach+GridViewsContaining.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension ForEach: GridForEachRangeInt where Data == Range<Int>, ID == Int, Content: View {
  var contentViews: [GridElement] {
    self.data.flatMap {
      self.content($0).extractContentViews()
    }
  }
}

extension ForEach: GridForEachIdentifiable where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
  var contentViews: [GridElement] {
    self.data.enumerated().flatMap { (_, dataElement: Data.Element) -> [GridElement] in
      let view = self.content(dataElement)
      return view.extractContentViews().enumerated().map {
        var identifiedView = $0.element
        if let identifiedHash = identifiedView.id {
          identifiedView.id = AnyHashable([
            identifiedHash,
            AnyHashable(dataElement.id)
          ])
        } else {
          identifiedView.id = AnyHashable([
            AnyHashable(dataElement.id),
            AnyHashable($0.offset)
          ])
        }
        return identifiedView
      }
    }
  }
}

extension ForEach: GridForEachID where Content: View {
  var contentViews: [GridElement] {
    self.data.flatMap {
      self.content($0).extractContentViews()
    }
  }
}

#if DEBUG

// To be available on preview canvas

extension ModifiedContent: GridForEachRangeInt where Content: GridForEachRangeInt, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
  var contentViews: [GridElement] {
    return self.content.contentViews
  }
}

extension ModifiedContent: GridForEachIdentifiable where Content: GridForEachIdentifiable, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
  var contentViews: [GridElement] {
    return self.content.contentViews
  }
}

extension ModifiedContent: GridForEachID where Content: GridForEachID, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
  var contentViews: [GridElement] {
    return self.content.contentViews
  }
}

#endif
