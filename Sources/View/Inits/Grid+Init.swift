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
    tracks: Int,
    contentMode: GridContentMode? = nil,
    flow: GridFlow? = nil,
    packing: GridPacking? = nil,
    spacing: GridSpacing = Constants.defaultSpacing,
    commonItemsAlignment: GridAlignment? = nil,
    contentAlignment: GridAlignment? = nil,
    cache: GridCacheMode? = nil,
    @GridBuilder content: @escaping () -> GridBuilderResult) {
    self.init(
      tracks: [GridTrack](integerLiteral: tracks),
      contentMode: contentMode,
      flow: flow,
      packing: packing,
      spacing: spacing,
      commonItemsAlignment: commonItemsAlignment,
      contentAlignment: contentAlignment,
      cache: cache,
      content: content
    )
  }

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
    let itemsBuilder = {
      let content = content()
      var index = 0
      return content.contentViews.asGridElements(index: &index)
    }
    self.init(
      itemsBuilder: itemsBuilder,
      spacing: spacing,
      trackSizes: tracks,
      internalFlow: flow,
      internalPacking: packing,
      internalContentMode: contentMode,
      internalCacheMode: cache,
      internalCommonItemsAlignment: commonItemsAlignment,
      internalContentAlignment: contentAlignment
    )
  }
}
