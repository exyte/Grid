//
//  GridView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct GridItemPreferenceData {
    
    var columnSpan: Int
    var rowSpan: Int
}

struct GridItemPreferenceKey: PreferenceKey {
    typealias Value = [GridItemPreferenceData]

    static var defaultValue: [GridItemPreferenceData] = [GridItemPreferenceData(columnSpan: 99, rowSpan: 99)]

    static func reduce(value: inout [GridItemPreferenceData], nextValue: () -> [GridItemPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct GridViewWrapper: View {
    let innerView: AnyView?
    var columnSpan: Int
    var rowSpan: Int
    
    var body: some View {
        innerView
    }
}

struct Grid<Content>: View where Content: View {
    let items: [GridItem]
    let columnsCount: Int
    private let arranger = LayoutArrangerImpl() as LayoutArranger
    
    private lazy var arrangement: LayoutArrangement = {
        let arrangement = self.arranger.arrange(items: self.items,
                                                columnsCount: self.columnsCount)
        print(arrangement)
        return arrangement
    }()
    
    var body: some View {
        return VStack {
            ForEach(self.items, id: \.id) { item in
                item.view.overlay(Text("\(item.tag ?? "") \(item.columnSpan) / \(item.rowSpan)").foregroundColor(.white))
                
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        return Grid(columnsCount: 1) {
            Color(.red).span(column: 2, row: 44)
            Color(.blue)
        }
    }
}

extension GridItem {
    fileprivate init<T: View>(value: T) {
        let gridItem: GridItem
        
        if let wrapper = value as? GridViewWrapper {
            gridItem = GridItem(rowSpan: wrapper.rowSpan,
                                columnSpan: wrapper.columnSpan,
                                view: wrapper.innerView)
        } else if let previewContent = value as? ModifiedContent<GridViewWrapper, _IdentifiedModifier<__DesignTimeSelectionIdentifier>> {
            gridItem = GridItem(rowSpan: previewContent.content.rowSpan,
                                columnSpan: previewContent.content.columnSpan,
                                view: previewContent.content.innerView)
        } else {
            gridItem = GridItem(rowSpan: 1,
                                columnSpan: 1,
                                view: AnyView(value))
        }
        self = gridItem
    }
}

extension Grid {
    public init<C0: View, C1: View>(columnsCount: Int, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1)> {
        self.items = [GridItem(value: content().value.0),
                      GridItem(value: content().value.1)]
        self.columnsCount = columnsCount
    }
    
    //TODO: Generate for other variants
}

extension View {
    func span(column: Int, row: Int) -> GridViewWrapper {
        return GridViewWrapper(innerView: AnyView(self), columnSpan: column, rowSpan: row)
    }
}
