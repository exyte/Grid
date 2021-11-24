//
//  Grid+Inits_TupleView.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 18.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension Grid {
  public init(
    tracks: [GridTrack] = 1,
    contentMode: GridContentMode? = nil,
    flow: GridFlow? = nil,
    packing: GridPacking? = nil,
    spacing: GridSpacing = Constants.defaultSpacing,
    commonItemsAlignment: GridAlignment? = nil,
    contentAlignment: GridAlignment? = nil,
    cache: GridCacheMode? = nil,
    @GridBuilder content: @escaping () -> GridBuilderResult) {
    self.trackSizes = tracks
    self.spacing = spacing
    self.internalContentMode = contentMode
    self.internalFlow = flow
    self.internalPacking = packing
    self.internalCacheMode = cache
    self.internalCommonItemsAlignment = commonItemsAlignment
    self.internalContentAlignment = contentAlignment

    itemsBuilder = {
      let content = content()
      var index = 0
      return content.contentViews.asGridElements(index: &index)
    }
  }
}
