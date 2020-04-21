//
//  GridView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct Grid<Content>: View where Content: View {
    @State var layout: LayoutArrangement?
    @State var positions: PositionPreference = .default

    var items: [GridItem] = []
    let columnsCount: Int
    private let arranger = LayoutArrangerImpl() as LayoutArranger
    
    var body: some View {
        return GeometryReader { mainGeometry in
            ZStack(alignment: .topLeading) {
                ForEach(self.items) { item in
                    item.view
                        .frame(width: self.positions[item]?.bounds.width,
                               height: self.positions[item]?.bounds.height)
                        .alignmentGuide(.leading, computeValue: { _ in  -(self.positions[item]?.bounds.origin.x ?? 0) })
                        .alignmentGuide(.top, computeValue: { _ in  -(self.positions[item]?.bounds.origin.y ?? 0) })
                        .transformPreference(SpanPreferenceKey.self) { preference in
                            preference.shrinkToLast(with: item)
                        }
                        .background(
                            Color.clear
                                .anchorPreference(key: PositionPreferenceKey.self, value: .bounds) {
                                    PositionPreference(items: [PositionedItem(bounds: mainGeometry[$0], gridItem: item)])
                                }
                        )
                        .overlay(
                            Text("x:\(0 - (self.positions[item]?.bounds.origin.x ?? 0))" +
                                " y:\(0 - (self.positions[item]?.bounds.origin.y ?? 0))")
                        )
                }
            }
            .transformPreference(PositionPreferenceKey.self) { positions in
                // TODO: Calculate positions
                guard let layout = self.layout else { return }
                var newPositions = PositionPreference.default
                
                for positionedItem in positions.items {
                    // TODO: Extract calculations
                    guard let arrangedItem = layout[positionedItem.gridItem] else { continue }
                    let columnSize = mainGeometry.size.width / CGFloat(layout.columnsCount)
                    let rowSize = mainGeometry.size.height / CGFloat(layout.rowsCount)
                    let itemWidth = CGFloat(arrangedItem.columnsCount) * columnSize
                    let itemHeight = rowSize * CGFloat(arrangedItem.rowsCount)
                    let positionX = CGFloat(arrangedItem.startPosition.column) * columnSize
                    let positionY = rowSize * CGFloat(arrangedItem.startPosition.row)
                    let newBounds = CGRect(x: positionX, y: positionY, width: itemWidth, height: itemHeight)
                    newPositions.items.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
                }
                
                positions = newPositions
            }
        }
        .onPreferenceChange(SpanPreferenceKey.self) { spanPreferences in
            print("onPreferenceChange: ")
            self.calculateLayout(spanPreferences: spanPreferences)
        }
        .onPreferenceChange(PositionPreferenceKey.self) { preferences in
            self.positions = preferences
        }
        .overlay(
            Text(layout?.description ?? "")
                .font(.system(size: 30, design: .monospaced))
        )
    }
    
    private func calculateLayout(spanPreferences: SpanPreferenceKey.Value) {
        let calculatedLayout = self.arranger.arrange(preferences: spanPreferences,
                                                     columnsCount: self.columnsCount)
        self.layout = calculatedLayout
        print(calculatedLayout)
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        return Grid(columnsCount: 4) {
            Color(.blue).gridSpan(column: 4)
            Color(.red).gridSpan(row: 3)
            Color(.yellow)
            Color(.purple).gridSpan(column: 2)
            Color(.green).gridSpan(column: 3, row: 3)
            Color(.orange).gridSpan(column: 3, row: 3)
        }
    }
}

extension View {
    func gridSpan(column: Int = Constants.defaultColumnSpan, row: Int = Constants.defaultRowSpan) -> some View {
        preference(key: SpanPreferenceKey.self,
                   value: [SpanPreference(span: GridSpan(row: row,
                                                         column: column))])
    }
}

extension Array where Element == SpanPreference {
    mutating func shrinkToLast(with item: GridItem) {
        guard
            var lastPreference = self.last
        else {
            return
        }
        lastPreference.item = item
        self = [lastPreference]
    }
}
