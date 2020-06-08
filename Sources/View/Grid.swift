//
//  Grid.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

public struct Grid<Content>: View, LayoutArranging, LayoutPositioning where Content: View {

    @State var arrangement: LayoutArrangement?
    @State var spans: SpanPreference?
    @State var starts: StartPreference?
    @State var positions: PositionsPreference = .default
    @State var lastArrangingPreferences: ArrangingPreference?
    @State var isLoaded: Bool = false
    @Environment(\.gridContentMode) private var environmentContentMode
    @Environment(\.gridFlow) private var environmentFlow
    @Environment(\.gridPacking) private var environmentPacking
    @Environment(\.gridAnimation) private var gridAnimation
    
    let items: [GridItem]
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
                    ForEach(self.items) { item in
                        item.view
                            .transformPreference(SpansPreferenceKey.self) { preference in
                                if var lastItem = preference?.items.last {
                                    lastItem.gridItem = item
                                    preference?.items = [lastItem]
                                } else {
                                    preference = SpanPreference(items: [.init(gridItem: item)])
                                }
                            }
                            .transformPreference(StartPreferenceKey.self) { preference in
                                if var lastItem = preference?.items.last {
                                    lastItem.gridItem = item
                                    preference?.items = [lastItem]
                                } else {
                                    preference = StartPreference(items: [.init(gridItem: item)])
                                }
                            }
                            .padding(spacing: self.spacing)
                            .background(self.positionsPreferencesSetter(item: item))
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
                .frame(minWidth: self.positions.size?.width,
                       maxWidth: .infinity,
                       minHeight: self.positions.size?.height,
                       maxHeight: .infinity,
                       alignment: .topLeading)
            }
            .transformPreference(ArrangingPreferenceKey.self) { preference in
                guard let starts = self.starts, let spans = self.spans else {
                    preference = nil
                    return
                }
                preference = ArrangingPreference(gridItems: self.items,
                                                 starts: starts,
                                                 spans: spans,
                                                 tracks: self.trackSizes,
                                                 flow: self.flow,
                                                 packing: self.packing)
            }
            .transformPreference(PositionsPreferenceKey.self) { preference in
                guard let arrangement = self.arrangement else { return }
                preference.environment = .init(arrangement: arrangement,
                                               boundingSize: self.corrected(size: mainGeometry.size),
                                               tracks: self.trackSizes,
                                               contentMode: self.contentMode,
                                               flow: self.flow)
            }

            .onPreferenceChange(SpansPreferenceKey.self) { spanPreferences in
                self.spans = spanPreferences
            }
            .onPreferenceChange(StartPreferenceKey.self) { startPreferences in
                self.starts = startPreferences
            }
            .onPreferenceChange(ArrangingPreferenceKey.self) { arrangingPreferences in
                guard
                    arrangingPreferences != nil,
                    let starts = self.starts,
                    let spans = self.spans
                else {
                    return
                }
                let preferences = ArrangingPreference(gridItems: self.items,
                                                      starts: starts,
                                                      spans: spans,
                                                      tracks: self.trackSizes,
                                                      flow: self.flow,
                                                      packing: self.packing)
                guard preferences != self.lastArrangingPreferences else { return }
                self.lastArrangingPreferences = preferences
                self.calculateArrangement(preferences: preferences)
            }
            .onPreferenceChange(PositionsPreferenceKey.self) { positionsPreference in
                guard let arrangement = self.arrangement else { return }
                let positions =
                    PositionsPreference(items: positionsPreference.items,
                                        size: positionsPreference.size,
                                        environment: .init(arrangement: arrangement,
                                                           boundingSize: self.corrected(size: mainGeometry.size),
                                                           tracks: self.trackSizes,
                                                           contentMode: self.contentMode,
                                                           flow: self.flow))
                self.positions = self.reposition(positions)
                self.isLoaded = true
            }
        }
        .opacity(self.isLoaded ? 1 : 0)
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

    private func calculateArrangement(preferences: ArrangingPreference) {
        let calculatedLayout = self.arrange(preferences: preferences)
        self.arrangement = calculatedLayout
    }
    
    private func cellPreferenceView<T: GridCellPreference>(item: GridItem, preference: T) -> some View {
        GeometryReader { geometry in
            preference.content(geometry.size)
        }
        .padding(spacing: self.spacing)
        .frame(width: self.positions[item]?.bounds.width,
               height: self.positions[item]?.bounds.height)
    }
    
    private func positionsPreferencesSetter(item: GridItem) -> some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: PositionsPreferenceKey.self,
                            value: PositionsPreference(items: [
                                PositionedItem(bounds: CGRect(origin: .zero, size: geometry.size),
                                               gridItem: item)],
                                                       size: nil)
            )
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
