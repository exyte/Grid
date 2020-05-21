//
//  Grid.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

public struct Grid<Content>: View, LayoutArranging, LayoutPositioning where Content: View {
    
    @State var arrangement: LayoutArrangement? = nil
    @State var positions: PositionsPreference = .default
    @State var spanPreferences: [SpanPreference] = []
    @Environment(\.gridContentMode) private var contentMode
    @Environment(\.gridFlow) private var flow
    @Environment(\.gridPacking) private var packing
    
    let items: [GridItem]
    let spacing: GridSpacing
    let trackSizes: [GridTrack]

    public var body: some View {
        return GeometryReader { mainGeometry in
            ScrollView(self.scrollAxis) {
                ZStack(alignment: .topLeading) {
                    ForEach(self.items) { item in
                        item.view
                            .transformPreference(SpansPreferenceKey.self) { preference in
                                preference.shrinkToLast(assigning: item)
                            }
                            .transformPreference(StartPreferenceKey.self) { preference in
                                if var lastStart = preference?.starts.last {
                                    lastStart.item = item
                                    preference?.starts = [lastStart]
                                }
                            }
                            .padding(spacing: self.spacing)
                            .anchorPreference(key: PositionsPreferenceKey.self, value: .bounds) {
                                PositionsPreference(items: [PositionedItem(bounds: mainGeometry[$0], gridItem: item)], size: nil)
                            }
                            .frame(flow: self.flow,
                                   size: self.positions[item]?.bounds.size,
                                   contentMode: self.contentMode)
                            .alignmentGuide(.leading, computeValue: { _ in  -(self.positions[item]?.bounds.origin.x ?? 0) })
                            .alignmentGuide(.top, computeValue: { _ in  -(self.positions[item]?.bounds.origin.y ?? 0) })
                            .backgroundPreferenceValue(GridBackgroundPreferenceKey.self) { preference in
                                self.cellPreferenceView(item: item, preference: preference)
                            }
                            .overlayPreferenceValue(GridOverlayPreferenceKey.self) { preference in
                                self.cellPreferenceView(item: item, preference: preference)
                            }
                    }
                }
                .frame(flow: self.flow,
                       size: mainGeometry.size,
                       contentMode: self.contentMode)
                .frame(minWidth: self.positions.size?.width,
                       maxWidth: .infinity,
                       minHeight: self.positions.size?.height,
                       maxHeight: .infinity,
                       alignment: .topLeading)
            }
            .transformPreference(SpansPreferenceKey.self) { preference in
                preference = preference.filter { $0.item != nil }
            }
            .transformPreference(StartPreferenceKey.self) { preference in
                preference = StartPreference(starts: preference?.starts ?? [],
                                             environment: .init(tracks: self.trackSizes,
                                                                flow: self.flow,
                                                                packing: self.packing,
                                                                spans: self.spanPreferences))
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
                self.spanPreferences = spanPreferences
            }
            .onPreferenceChange(StartPreferenceKey.self) { startPreferences in
                guard let starts = startPreferences, !self.spanPreferences.isEmpty else { return }
                self.calculateArrangement(spans: self.spanPreferences, starts: starts)
            }
            .onPreferenceChange(PositionsPreferenceKey.self) { positionsPreference in
                guard let arrangement = self.arrangement else {
                    return
                }
                let newPositions = self.reposition(positionsPreference,
                                                   arrangement: arrangement,
                                                   boundingSize: self.corrected(size: mainGeometry.size),
                                                   tracks: self.trackSizes,
                                                   contentMode: self.contentMode,
                                                   flow: self.flow)
                
                if self.positions.items.isEmpty {
                    self.positions = newPositions
                } else {
                    DispatchQueue.main.async {
                        self.positions = newPositions
                    }
                }
            }
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

    private func calculateArrangement(spans: [SpanPreference], starts: StartPreference) {
        let calculatedLayout = self.arrange(spanPreferences: spans,
                                            startPreferences: starts,
                                            fixedTracksCount: self.trackSizes.count,
                                            flow: self.flow,
                                            packing: self.packing)
        self.arrangement = calculatedLayout
        print(calculatedLayout)
    }
    
    private func cellPreferenceView<T: GridCellPreference>(item: GridItem, preference: T) -> some View {
        GeometryReader { geometry in
            preference.content(geometry.size)
        }
        .padding(spacing: self.spacing)
        .frame(width: self.positions[item]?.bounds.width,
               height: self.positions[item]?.bounds.height)
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

extension Array where Element: GridItemContaining {
    fileprivate mutating func shrinkToLast(assigning item: GridItem) {
        guard var lastPreference = self.last else { return }
        lastPreference.item = item
        self = [lastPreference]
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            Grid(0..<15, tracks: 5, spacing: 5) { item in
                if item % 2 == 0 {
                    Color(.red)
                        .overlay(Text("\(item)").foregroundColor(.white))
                        .gridSpan(column: 2, row: 1)
                } else {
                    Color(.blue)
                        .overlay(Text("\(item)").foregroundColor(.white))
                }
            }
            
            Divider()
            
            Grid(tracks: 4, spacing: 5) {
                
                ForEach(0..<10) { _ in
                    Color.black
                }
                Color(.brown)
                    .gridSpan(column: 3, row: 1)
                
                Color(.blue)
                    .gridSpan(column: 2, row: 2)
                
                Color(.red)
                    .gridSpan(column: 1, row: 1)
                
                Color(.yellow)
                    .gridSpan(column: 1, row: 1)

                Color(.purple)
                    .gridSpan(column: 1, row: 2)

                Color(.green)
                    .gridSpan(column: 2, row: 3)

                Color(.orange)
                    .gridSpan(column: 1, row: 3)
                
                Color(.gray)
            }
        }
        .gridFlow(.rows)
        .gridPacking(.dense)
    }
}
