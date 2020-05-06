//
//  Grid.swift
//  GridLayout
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

public struct Grid<Content>: View, LayoutArranging where Content: View {
    
    @State var arrangement: LayoutArrangement?
    @State var positions: PositionsPreference = .default
    @Environment(\.gridContentMode) private var contentMode
    @Environment(\.gridFlow) private var flow
    @Environment(\.gridPacking) private var packing
    
    let items: [GridItem]
    let tracksCount: Int
    let spacing: CGFloat
    let trackSizes: [TrackSize]

    public var body: some View {
        return GeometryReader { mainGeometry in
            ScrollView(self.scrollAxis) {
                ZStack(alignment: .topLeading) {
                    ForEach(self.items) { item in
                        item.view
                            .transformPreference(SpansPreferenceKey.self) { preference in
                                preference.shrinkToLast(assigning: item)
                            }
                            .padding(self.paddingEdges(item: item), self.spacing)
                            .frame(flow: self.flow,
                                   bounds: self.positions[item]?.bounds,
                                   contentMode: self.contentMode)
                            .alignmentGuide(.leading, computeValue: { _ in  -(self.positions[item]?.bounds.origin.x ?? 0) })
                            .alignmentGuide(.top, computeValue: { _ in  -(self.positions[item]?.bounds.origin.y ?? 0) })
                            .overlay(
                                Color.clear
                                    .border(Color.black, width: 1)
                                    .frame(width: self.positions[item]?.bounds.width,
                                           height: self.positions[item]?.bounds.height)
                            )
                            .anchorPreference(key: PositionsPreferenceKey.self, value: .bounds) {
                                let padding = self.paddingEdges(item: item)
                                let additionalWidth = padding.contains(.leading) ? self.spacing : 0
                                let additionalHeight = padding.contains(.top) ? self.spacing : 0
                                var bounds = mainGeometry[$0]
                                bounds.size.width += 300
                                bounds.size.height += additionalHeight
                                return PositionsPreference(items: [PositionedItem(bounds: bounds, gridItem: item)], size: .zero)
                            }
                            .backgroundPreferenceValue(GridBackgroundPreferenceKey.self) { preference in
                                self.cellPreferenceView(item: item, preference: preference)
                            }
                            .overlayPreferenceValue(GridOverlayPreferenceKey.self) { preference in
                                self.cellPreferenceView(item: item, preference: preference)
                            }
                    }
                }
                .frame(minWidth: self.positions.size.width,
                       maxWidth: .infinity,
                       minHeight: self.positions.size.height,
                       maxHeight: .infinity,
                       alignment: .topLeading)
                }
                .transformPreference(PositionsPreferenceKey.self) { positionPreference in
                    guard let arrangement = self.arrangement else { return }
                    positionPreference = self.reposition(positionPreference,
                                                         arrangement: arrangement,
                                                         boundingSize: mainGeometry.size,
                                                         tracks: self.trackSizes,
                                                         contentMode: self.contentMode,
                                                         flow: self.flow,
                                                         spacing: self.spacing)
            }
        }
        .transformPreference(SpansPreferenceKey.self) { preference in
            preference = preference.filter { $0.item != nil }
        }
        .onPreferenceChange(SpansPreferenceKey.self) { spanPreferences in
            self.calculateArrangement(spans: spanPreferences)
        }
        .onPreferenceChange(PositionsPreferenceKey.self) { positionsPreference in
            self.positions = positionsPreference
        }
    }
    
    private var scrollAxis: Axis.Set {
        if case .fill = self.contentMode {
            return []
        }
        return self.flow == .columns ? .vertical : .horizontal
    }

    private func calculateArrangement(spans: [SpanPreference]) {
        let calculatedLayout = self.arrange(spanPreferences: spans,
                                            fixedTracksCount: self.tracksCount,
                                            flow: self.flow,
                                            packing: self.packing)
        self.arrangement = calculatedLayout
        print(calculatedLayout)
    }
    
    private func paddingEdges(item: GridItem) -> Edge.Set {
        var edges: Edge.Set = []
        guard let arrangedItem = self.arrangement?[item] else { return edges }
        if arrangedItem.startIndex.row != 0 {
            edges.update(with: .top)
        }
        if arrangedItem.startIndex.column != 0 {
            edges.update(with: .leading)
        }
        return edges
    }
    
    @ViewBuilder
    private func cellPreferenceView<T: GridCellPreference>(item: GridItem, preference: T) -> some View {
        GeometryReader { geometry in
            preference.content(geometry.size)
        }
        .padding(self.paddingEdges(item: item), self.spacing)
        .frame(width: self.positions[item]?.bounds.width,
               height: self.positions[item]?.bounds.height)
    }
}

extension View {
    fileprivate func frame(flow: GridFlow, bounds: CGRect?,
                           contentMode: GridContentMode) -> some View {
        let width: CGFloat?
        let height: CGFloat?
        
        switch contentMode {
        case .fill:
            width = bounds?.width
            height = bounds?.height
        case .scroll:
            width = (flow == .columns ? bounds?.width : nil)
            height = (flow == .columns ? nil : bounds?.height)
        }
        return frame(width: width, height: height)
    }
}

extension Array where Element == SpanPreference {
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
        .gridFlow(.columns)
        .gridPacking(.sparse)
    }
}
