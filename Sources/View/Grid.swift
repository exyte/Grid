//
//  Grid.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

public struct Grid<Content>: View, LayoutArranging, LayoutPositioning where Content: View {
    @State var positions: PositionedLayout = .empty
    @State var isLoaded: Bool = false
    @Environment(\.gridContentMode) private var environmentContentMode
    @Environment(\.gridFlow) private var environmentFlow
    @Environment(\.gridPacking) private var environmentPacking
    @Environment(\.gridAnimation) private var gridAnimation
    @State var overriddenIDs: [[GridItem]: Set<IDPair>] = [:]
    
    let items: [GridItem]
    var overridenItems: [GridItem] {
        let newItems = items.map { item -> GridItem in
            let newIDPair = overriddenIDs[self.items]?.first {
                $0.originID == item.id
            }
            return GridItem(item.view,
                            idPair: newIDPair ?? item.idPair)
        }
        return newItems
    }

    let spacing: GridSpacing
    let trackSizes: [GridTrack]
    
    var internalFlow: GridFlow?
    var internalPacking: GridPacking?
    var internalContentMode: GridContentMode?

    private var flow: GridFlow {
        self.internalFlow ?? self.environmentFlow ?? Constants.defaultFlow
    }
    
    private var packing: GridPacking {
        self.internalPacking ?? self.environmentPacking ?? Constants.defaultPacking
    }
    
    private var contentMode: GridContentMode {
        self.internalContentMode ?? self.environmentContentMode ?? Constants.defaultContentMode
    }

    public var body: some View {
        return GeometryReader { mainGeometry in
            ScrollView(self.scrollAxis) {
                ZStack(alignment: .topLeading) {
                    ForEach(self.overridenItems) { item in
                        item.view
                            .padding(spacing: self.spacing)
                            .background(self.positionsPreferencesSetter(item: item,
                                                                        boundingSize: mainGeometry.size))
                            .transformPreference(GridPreferenceKey.self) { preference in
                                var mergedInfo = preference.itemsInfo.mergedToSingleValue
                                var newIDPair = mergedInfo.idPair ?? IDPair()
                                newIDPair.originID = item.idPair.originID
                                mergedInfo.idPair = newIDPair
                                preference.itemsInfo = [mergedInfo]
                            }
                            .frame(flow: self.flow,
                                   size: self.positions[item]?.bounds.size,
                                   contentMode: self.contentMode)
                            .alignmentGuide(.leading, computeValue: { _ in self.leadingGuide(item: item) })
                            .alignmentGuide(.top, computeValue: { _ in self.topGuide(item: item) })
                            .backgroundPreferenceValue(GridBackgroundPreferenceKey.self) { preference in
                                self.cellPreferenceView(item: item, preference: preference)
                            }
                            .overlayPreferenceValue(GridOverlayPreferenceKey.self) { preference in
                                self.cellPreferenceView(item: item, preference: preference)
                            }
                    }
                }
                .animation(self.gridAnimation)
                .frame(flow: self.flow,
                       size: mainGeometry.size,
                       contentMode: self.contentMode)
            }
            .onPreferenceChange(GridPreferenceKey.self) { preference in
                self.calculateLayout(preference: preference,
                                     boundingSize: mainGeometry.size)
            }
        }
        .id(self.isLoaded)
    }
    
    private func calculateLayout(preference: GridPreference, boundingSize: CGSize) {
        let task = ArrangingTask(itemsInfo: preference.itemsInfo.asArrangementInfo,
                                 tracks: self.trackSizes,
                                 flow: self.flow,
                                 packing: self.packing)
        let calculatedLayout = self.arrange(task: task)
        let positionTask = PositioningTask(items: preference.itemsInfo.compactMap(\.positionedItem),
                                           arrangement: calculatedLayout,
                                           boundingSize: self.corrected(size: boundingSize),
                                           tracks: self.trackSizes,
                                           contentMode: self.contentMode,
                                           flow: self.flow)
        let positions = self.reposition(positionTask)
        if self.positions != positions {
            self.positions = positions
        }
        self.isLoaded = true

        let existingItemsStruct = self.overriddenIDs[self.items]
        if existingItemsStruct != preference.overriddenIDs {
            self.overriddenIDs[self.items] = preference.overriddenIDs
        }


    }
    
    private func corrected(size: CGSize) -> CGSize {
        return CGSize(width: size.width - self.spacing.horizontal,
                      height: size.height - self.spacing.vertical)
    }
    
    private var scrollAxis: Axis.Set {
        if case .fill = self.contentMode {
            return []
        }
        return self.flow == .rows ? .vertical : .horizontal
    }
    
    private func leadingGuide(item: GridItem) -> CGFloat {
        return -(self.positions[item]?.bounds.origin.x ?? CGFloat(-self.spacing.horizontal) / 2.0)
    }
    
    private func topGuide(item: GridItem) -> CGFloat {
        -(self.positions[item]?.bounds.origin.y ?? CGFloat(-self.spacing.vertical) / 2.0)
    }

    private func cellPreferenceView<T: GridCellPreference>(item: GridItem, preference: T) -> some View {
        GeometryReader { geometry in
            preference.content(geometry.size)
        }
        .padding(spacing: self.spacing)
        .frame(width: self.positions[item]?.bounds.width,
               height: self.positions[item]?.bounds.height)
    }
    
    private func positionsPreferencesSetter(item: GridItem, boundingSize: CGSize) -> some View {
        GeometryReader { geometry in
            Color.clear
                .transformPreference(GridPreferenceKey.self, { preference in
                    let positionedItem = PositionedItem(bounds: CGRect(origin: .zero, size: geometry.size),
                                                        gridItem: item)
                    let info = GridPreference.ItemInfo(positionedItem: positionedItem)
                    let environment = GridPreference.Environment(tracks: self.trackSizes,
                                                                 contentMode: self.contentMode,
                                                                 flow: self.flow,
                                                                 packing: self.packing,
                                                                 boundingSize: boundingSize)
                    preference = GridPreference(itemsInfo: [info], environment: environment)
                })
        }
    }
}

extension View {
    fileprivate func frame(flow: GridFlow, size: CGSize?,
                           contentMode: GridContentMode) -> some View {
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
        return frame(width: width, height: height)
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
