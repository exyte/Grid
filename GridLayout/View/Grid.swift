//
//  Grid.swift
//  GridLayout
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

public struct Grid<Content>: View where Content: View {
    
    @State var arrangement: LayoutArrangement?
    @State var positions: PositionsPreference = .default
    @Environment(\.contentMode) private var contentMode
    
    let items: [GridItem]
    let columnCount: Int
    let spacing: CGFloat
    let trackSizes: [TrackSize]
    let flow: GridFlow = .columns // TODO: Handle rows
    
    private let arranger = LayoutArrangerImpl() as LayoutArranger

    public var body: some View {
        return GeometryReader { mainGeometry in
            ScrollView(self.scrollAxis) {
                ZStack(alignment: .topLeading) {
                    ForEach(self.items) { item in
                        item.view // TODO: Add spacing
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
                            .transformPreference(SpansPreferenceKey.self) { $0.shrinkToLast(assigning: item) }
                            .anchorPreference(key: PositionsPreferenceKey.self, value: .bounds) {
                                PositionsPreference(items: [PositionedItem(bounds: mainGeometry[$0], gridItem: item)], size: .zero)
                            }
                            .backgroundPreferenceValue(GridBackgroundPreferenceKey.self) { preference in
                                preference.content(self.positions[item]?.bounds)
                            }
                            .overlayPreferenceValue(GridOverlayPreferenceKey.self) { preference in
                                preference.content(self.positions[item]?.bounds)
                            }
                    }
                }
                .transformPreference(PositionsPreferenceKey.self) { positionPreference in
                    guard let arrangement = self.arrangement else { return }
                    positionPreference = self.arranger.reposition(positionPreference,
                                                                  arrangement: arrangement,
                                                                  boundingSize: mainGeometry.size,
                                                                  tracks: self.trackSizes,
                                                                  contentMode: self.contentMode)
                }
                .frame(minWidth: self.positions.size.width,
                       maxWidth: .infinity,
                       minHeight: self.positions.size.height,
                       maxHeight: .infinity,
                       alignment: .top)
                }
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
        let calculatedLayout = self.arranger.arrange(spanPreferences: spans,
                                                     columnsCount: self.columnCount)
        self.arrangement = calculatedLayout
        print(calculatedLayout)
    }
    
    private func paddingEdges(item: GridItem) -> Edge.Set {
        var edges: Edge.Set = []
        guard let arrangedItem = self.arrangement?[item] else { return edges }
        if arrangedItem.startPoint.row != 0 {
            edges.update(with: .top)
        }
        if arrangedItem.startPoint.column != 0 {
            edges.update(with: .leading)
        }
        return edges
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
            Grid(0..<30, columns: 5, spacing: 5) { item in
                if item % 2 == 0 {
                    Color(.red)
                        .overlay(Text("\(item)").foregroundColor(.white))
                        .gridSpan(column: 1, row: 2)
                } else {
                    Color(.blue)
                        .overlay(Text("\(item)").foregroundColor(.white))
                }
            }
            
            Divider()
            
            Grid(columns: [.fr(1), .fr(2), .fr(3), .fr(10)], spacing: 5) {
                Color(.brown)
                    .gridSpan(column: 4)
                
                Color(.blue)
                    .gridSpan(column: 4)
                
                Color(.red)
                    .gridSpan(row: 3)
                
                Color(.yellow)
                
                Color(.purple)
                    .gridSpan(column: 2)
                
                Color(.green)
                    .gridSpan(column: 3, row: 3)
                
                Color(.orange)
                    .gridSpan(column: 3, row: 3)
                
                Color(.gray)
            }
        }
    }
}
