//
//  ForEach+GridViewsContaining.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension ForEach: GridForEachRangeInt where Data == Range<Int>, ID == Int, Content: View {
  var contentViews: [IdentifiedView] {
    self.data.flatMap {
      self.content($0).extractContentViews()
    }
  }
}

extension ForEach: GridForEachIdentifiable where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
  var contentViews: [IdentifiedView] {
    self.data.enumerated().flatMap { (_, dataElement: Data.Element) -> [IdentifiedView] in
      let view = self.content(dataElement)
      return view.extractContentViews().enumerated().map {
        var indentifiedView = $0.element
        if let identifiedHash = indentifiedView.hash {
          indentifiedView.hash = AnyHashable([identifiedHash,
                                              AnyHashable(dataElement.id)])
        } else {
          indentifiedView.hash = AnyHashable([AnyHashable(dataElement.id),
                                              AnyHashable($0.offset)])
        }
        return indentifiedView
      }
    }
  }
}

extension ForEach: GridForEachID where Content: View {
  var contentViews: [IdentifiedView] {
    self.data.flatMap {
      self.content($0).extractContentViews()
    }
  }
}

#if DEBUG

// To be available on preview canvas

extension ModifiedContent: GridForEachRangeInt where Content: GridForEachRangeInt, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
  var contentViews: [IdentifiedView] {
    return self.content.contentViews
  }
}

extension ModifiedContent: GridForEachIdentifiable where Content: GridForEachIdentifiable, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
  var contentViews: [IdentifiedView] {
    return self.content.contentViews
  }
}

extension ModifiedContent: GridForEachID where Content: GridForEachID, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
  var contentViews: [IdentifiedView] {
    return self.content.contentViews
  }
}

#endif
