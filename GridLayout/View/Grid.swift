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

    let items: [GridItem]
    let columns: Int
    private let arranger = LayoutArrangerImpl() as LayoutArranger
    
    public var body: some View {
        return GeometryReader { mainGeometry in
            ZStack(alignment: .topLeading) {
                ForEach(self.items) { item in
                    item.view
                        .frame(width: self.positions[item]?.bounds.width,
                               height: self.positions[item]?.bounds.height)
                        .alignmentGuide(.leading, computeValue: { _ in  -(self.positions[item]?.bounds.origin.x ?? 0) })
                        .alignmentGuide(.top, computeValue: { _ in  -(self.positions[item]?.bounds.origin.y ?? 0) })
                        .transformPreference(SpansPreferenceKey.self) { $0.shrinkToLast(with: item) }
                        .background(
                            Color.clear
                                .anchorPreference(key: PositionsPreferenceKey.self, value: .bounds) {
                                    PositionsPreference(items: [PositionedItem(bounds: mainGeometry[$0], gridItem: item)])
                                }
                        )
                        .overlay(
                            Text("x:\(-(self.positions[item]?.bounds.origin.x ?? 0))" +
                                " y:\(-(self.positions[item]?.bounds.origin.y ?? 0))")
                        )
                }
            }
            .transformPreference(PositionsPreferenceKey.self) { positionPreference in
                guard let arrangement = self.arrangement else { return }
                positionPreference.items = self.arranger.reposition(positionPreference.items,
                                                                    arrangement: arrangement,
                                                                    boundingSize: mainGeometry.size)
            }
        }
        .onPreferenceChange(SpansPreferenceKey.self) { spanPreferences in
            self.calculateArrangement(spans: spanPreferences)
        }
        .onPreferenceChange(PositionsPreferenceKey.self) { positionsPreference in
            self.positions = positionsPreference
        }
        .overlay(
            Text(arrangement?.description ?? "")
                .font(.system(size: 30, design: .monospaced))
        )
    }
    
    private func calculateArrangement(spans: [SpanPreference]) {
        let calculatedLayout = self.arranger.arrange(spanPreferences: spans,
                                                     columnsCount: self.columns)
        self.arrangement = calculatedLayout
        print(calculatedLayout)
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        Grid(columns: 4) {
            HStack(spacing: 5) {
                ForEach(0..<9, id: \.self) { _ in
                    Color(.brown)
                        .gridSpan(column: 33)
                }
            }
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
        }
    }
}

extension View {
    public func gridSpan(column: Int = Constants.defaultColumnSpan, row: Int = Constants.defaultRowSpan) -> some View {
        preference(key: SpansPreferenceKey.self,
                   value: [SpanPreference(span: GridSpan(row: row,
                                                         column: column))])
    }
}

extension Array where Element == SpanPreference {
    fileprivate mutating func shrinkToLast(with item: GridItem) {
        guard var lastPreference = self.last else { return }
        lastPreference.item = item
        self = [lastPreference]
    }
}
