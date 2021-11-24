//
//  GridGroup.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 18.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

public struct GridGroup: View, GridGroupContaining {
  
  public static var empty = GridGroup(contentViews: [])
  
  var contentViews: [GridElement]
  
  public var body = EmptyView()
}

#if DEBUG

// To be available on preview canvas

extension ModifiedContent: GridGroupContaining where Content: GridGroupContaining, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
  var contentViews: [GridElement] {
    return self.content.contentViews
  }
}

#endif
