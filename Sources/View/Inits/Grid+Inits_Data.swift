//
//  Grid+Inits_Data.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension Grid {
  public init<Data, ID>(
    _ data: Data,
    id: KeyPath<Data.Element, ID>,
    tracks: [GridTrack] = 1,
    contentMode: GridContentMode? = nil,
    flow: GridFlow? = nil,
    packing: GridPacking? = nil,
    spacing: GridSpacing = Constants.defaultSpacing,
    commonItemsAlignment: GridAlignment? = nil,
    contentAlignment: GridAlignment? = nil,
    cache: GridCacheMode? = nil,
    @GridBuilder item: @escaping (Data.Element) -> GridBuilderResult
  ) where Data: RandomAccessCollection, ID: Hashable {
    itemsBuilder = {
      var index = 0
      return data.flatMap {
        item($0).contentViews.asGridElements(
          index: &index,
          baseHash: AnyHashable([AnyHashable($0[keyPath: id]), AnyHashable(id)])
        )
      }
    }

    self.trackSizes = tracks
    self.spacing = spacing
    self.internalContentMode = contentMode
    self.internalFlow = flow
    self.internalPacking = packing
    self.internalCacheMode = cache
    self.internalCommonItemsAlignment = commonItemsAlignment
    self.internalContentAlignment = contentAlignment
  }
  
  public init(
    _ data: Range<Int>,
    tracks: [GridTrack] = 1,
    contentMode: GridContentMode? = nil,
    flow: GridFlow? = nil,
    packing: GridPacking? = nil,
    spacing: GridSpacing = Constants.defaultSpacing,
    commonItemsAlignment: GridAlignment? = nil,
    contentAlignment: GridAlignment? = nil,
    cache: GridCacheMode? = nil,
    @GridBuilder item: @escaping (Int) -> GridBuilderResult
  ) {
    itemsBuilder = {
      var index = 0
      return data.flatMap {
        item($0).contentViews.asGridElements(index: &index)
      }
    }

    self.trackSizes = tracks
    self.spacing = spacing
    self.internalContentMode = contentMode
    self.internalFlow = flow
    self.internalPacking = packing
    self.internalCacheMode = cache
    self.internalCommonItemsAlignment = commonItemsAlignment
    self.internalContentAlignment = contentAlignment
  }
  
  public init<Data>(
    _ data: Data,
    tracks: [GridTrack] = 1,
    contentMode: GridContentMode? = nil,
    flow: GridFlow? = nil,
    packing: GridPacking? = nil,
    spacing: GridSpacing = Constants.defaultSpacing,
    commonItemsAlignment: GridAlignment? = nil,
    contentAlignment: GridAlignment? = nil,
    cache: GridCacheMode? = nil,
    @GridBuilder item: @escaping (Data.Element) -> GridBuilderResult
  ) where Data: RandomAccessCollection, Data.Element: Identifiable {
    itemsBuilder = {
      var index = 0
      return data.flatMap {
        item($0).contentViews.asGridElements(
          index: &index,
          baseHash: AnyHashable($0.id)
        )
      }
    }

    self.trackSizes = tracks
    self.spacing = spacing
    self.internalContentMode = contentMode
    self.internalFlow = flow
    self.internalPacking = packing
    self.internalCacheMode = cache
    self.internalCommonItemsAlignment = commonItemsAlignment
    self.internalContentAlignment = contentAlignment
  }
}
