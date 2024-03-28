//
//  Grid.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

public struct Grid: View, LayoutArranging, LayoutPositioning {
  @State private var positions: PositionedLayout = .empty
  @State private var isLoaded: Bool = false
  @State private var alignments: [GridElement: GridAlignment] = [:]
  #if os(iOS) || os(watchOS) || os(tvOS)
  @State private var internalLayoutCache = Cache<ArrangingTask, LayoutArrangement>()
  @State private var internalPositionsCache = Cache<PositioningTask, PositionedLayout>()
  #endif
  @Environment(\.gridContentMode) private var environmentContentMode
  @Environment(\.gridFlow) private var environmentFlow
  @Environment(\.gridPacking) private var environmentPacking
  @Environment(\.gridAnimation) private var gridAnimation
  @Environment(\.gridCache) private var environmentCacheMode
  @Environment(\.gridCommonItemsAlignment) private var environmentCommonItemsAlignment
  @Environment(\.gridContentAlignment) private var environmentContentAlignment

  let itemsBuilder: () -> [GridElement]
  let spacing: GridSpacing
  let trackSizes: [GridTrack]
  var internalFlow: GridFlow?
  var internalPacking: GridPacking?
  var internalContentMode: GridContentMode?
  var internalCacheMode: GridCacheMode?
  var internalCommonItemsAlignment: GridAlignment?
  var internalContentAlignment: GridAlignment?

  private var flow: GridFlow {
    self.internalFlow ?? self.environmentFlow ?? Constants.defaultFlow
  }
  
  private var packing: GridPacking {
    self.internalPacking ?? self.environmentPacking ?? Constants.defaultPacking
  }
  
  private var contentMode: GridContentMode {
    self.internalContentMode ?? self.environmentContentMode ?? Constants.defaultContentMode
  }
  
  private var cacheMode: GridCacheMode {
    self.internalCacheMode ?? self.environmentCacheMode ?? Constants.defaultCacheMode
  }
  
  private var commonItemsAlignment: GridAlignment {
    self.internalCommonItemsAlignment ?? self.environmentCommonItemsAlignment ?? Constants.defaultCommonItemsAlignment
  }

  private var contentAlignment: GridAlignment {
    self.internalContentAlignment ?? self.environmentContentAlignment ?? Constants.defaultContentAlignment
  }
  
  #if os(iOS) || os(watchOS) || os(tvOS)
  
  private var layoutCache: Cache<ArrangingTask, LayoutArrangement>? {
    switch self.cacheMode {
    case .inMemoryCache:
      return self.internalLayoutCache
    case .noCache:
      return nil
    }
  }
  
  private var positionsCache: Cache<PositioningTask, PositionedLayout>? {
    switch self.cacheMode {
    case .inMemoryCache:
      return self.internalPositionsCache
    case .noCache:
      return nil
    }
  }
  
  #endif
  
  public var body: some View {
    GeometryReader { mainGeometry in
      ZStack(alignment: .topLeading) {
        ForEach(itemsBuilder()) { item in
          item.view
            .padding(spacing: self.spacing)
            .background(
              self.positionsPreferencesSetter(
                item: item,
                boundingSize: mainGeometry.size
              )
            )
            .transformPreference(GridPreferenceKey.self) { preference in
              preference.itemsInfo = preference.itemsInfo.mergedToSingleValue
            }
            .frame(
              flow: self.flow,
              size: self.positions[item]?.bounds.size,
              contentMode: self.contentMode,
              alignment: alignmentForItem(item)
            )
            .backgroundPreferenceValue(
              GridBackgroundPreferenceKey.self,
              alignment: alignmentForItem(item)
            ) { preference in
              self.cellPreferenceView(item: item, preference: preference)
            }
            .overlayPreferenceValue(
              GridOverlayPreferenceKey.self,
              alignment: alignmentForItem(item)
            ) { preference in
              self.cellPreferenceView(item: item, preference: preference)
            }
            .alignmentGuide(.leading, computeValue: { _ in self.leadingGuide(item: item) })
            .alignmentGuide(.top, computeValue: { _ in self.topGuide(item: item) })
        }
      }
      .frame(
        flow: self.flow,
        size: mainGeometry.size,
        contentMode: self.contentMode,
        alignment: self.contentAlignment.swiftUIAlignment
      )
      .if(contentMode == .scroll) { content in
        ScrollView(self.scrollAxis) { content }
      }
      .onPreferenceChange(GridPreferenceKey.self) { preference in
        withAnimation(self.gridAnimation) {
          self.calculateLayout(
            preference: preference,
            boundingSize: mainGeometry.size
          )
          self.saveAlignmentsFrom(preference: preference)
        }
      }
    }
    .id(self.isLoaded)
  }
  
  private func calculateLayout(preference: GridPreference, boundingSize: CGSize) {
    let task = ArrangingTask(itemsInfo: preference.itemsInfo.asArrangementInfo,
                             tracks: self.trackSizes,
                             flow: self.flow,
                             packing: self.packing)
    
    let calculatedLayout: LayoutArrangement
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    if let cachedLayout = self.layoutCache?.object(forKey: task) {
      calculatedLayout = cachedLayout
    } else {
      calculatedLayout = self.arrange(task: task)
      self.layoutCache?.setObject(calculatedLayout, forKey: task)
    }
    #else
    calculatedLayout = self.arrange(task: task)
    #endif
    let positionedItems = preference.itemsInfo.compactMap {
      var item = $0.positionedItem
      item?.alignment = $0.alignment ?? commonItemsAlignment
      return item
    }
    let positionTask = PositioningTask(
      items: positionedItems,
      arrangement: calculatedLayout,
      boundingSize: self.corrected(size: boundingSize),
      tracks: self.trackSizes,
      contentMode: self.contentMode,
      flow: self.flow
    )
    let positions: PositionedLayout
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    if let cachedPositions = self.positionsCache?.object(forKey: positionTask) {
      positions = cachedPositions
    } else {
      positions = self.reposition(positionTask)
      self.positionsCache?.setObject(positions, forKey: positionTask)
    }
    #else
    positions = self.reposition(positionTask)
    #endif
    
    self.positions = positions
    self.isLoaded = true
  }
  
  private func saveAlignmentsFrom(preference: GridPreference) {
    var alignments: [GridElement: GridAlignment] = [:]
    preference.itemsInfo.forEach {
      guard let gridElement = $0.positionedItem?.gridElement else { return }
      alignments[gridElement] = $0.alignment
    }
    self.alignments = alignments
  }
  
  private func corrected(size: CGSize) -> CGSize {
    return CGSize(width: size.width - self.spacing.horizontal,
                  height: size.height - self.spacing.vertical)
  }
  
  private var scrollAxis: Axis.Set {
    switch self.contentMode {
    case .fill:
      return []
    case .scroll:
      return self.flow == .rows ? .vertical : .horizontal
    }
  }
  
  private func leadingGuide(item: GridElement) -> CGFloat {
    -(self.positions[item]?.bounds.origin.x ?? CGFloat(-self.spacing.horizontal) / 2.0)
  }
  
  private func topGuide(item: GridElement) -> CGFloat {
    -(self.positions[item]?.bounds.origin.y ?? CGFloat(-self.spacing.vertical) / 2.0)
  }
  
  private func cellPreferenceView<T: GridCellPreference>(item: GridElement, preference: T) -> some View {
    GeometryReader { geometry in
      preference.content(geometry.size)
    }
    .padding(spacing: self.spacing)
    .frame(
      width: self.positions[item]?.bounds.width,
      height: self.positions[item]?.bounds.height
    )
  }
  
  private func positionsPreferencesSetter(item: GridElement, boundingSize: CGSize) -> some View {
    GeometryReader { geometry in
      Color.clear
        .transformPreference(GridPreferenceKey.self, { preference in
          let positionedItem = PositionedItem(
            bounds: CGRect(origin: .zero, size: geometry.size),
            gridElement: item
          )
          let info = GridPreference.ItemInfo(positionedItem: positionedItem)
          let environment = GridPreference.Environment(
            tracks: self.trackSizes,
            contentMode: self.contentMode,
            flow: self.flow,
            packing: self.packing,
            boundingSize: boundingSize
          )
          preference = GridPreference(itemsInfo: [info], environment: environment)
        })
    }
  }
  
  private func alignmentForItem(_ item: GridElement) -> Alignment {
    self.alignments[item]?.swiftUIAlignment ?? commonItemsAlignment.swiftUIAlignment
  }
}

extension View {
  fileprivate func frame(
    flow: GridFlow,
    size: CGSize?,
    contentMode: GridContentMode,
    alignment: Alignment = .center
  ) -> some View {
    let width: CGFloat?
    let height: CGFloat?
    
    switch contentMode {
    case .fill:
      width = size?.width
      height = size?.height
    case .scroll:
      width = (flow == .rows ? size?.width : nil)
      height = (flow == .columns ? size?.height : nil)
    }
    
    return frame(width: width, height: height, alignment: alignment)
  }

  fileprivate func padding(spacing: GridSpacing) -> some View {
    var edgeInsets = EdgeInsets()
    edgeInsets.top = spacing.vertical / 2
    edgeInsets.bottom = spacing.vertical / 2
    edgeInsets.leading = spacing.horizontal / 2
    edgeInsets.trailing = spacing.horizontal / 2
    return self.padding(edgeInsets)
  }
}
