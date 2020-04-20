//
//  GridView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct Grid<Content>: View where Content: View {
    @State var preferences: [SpanPreference] = []
    @State var layout: LayoutArrangement?

    var items: [GridItem] = []
    let columnsCount: Int
    private let arranger = LayoutArrangerImpl() as LayoutArranger

    var body: some View {
        return VStack {
            ForEach(self.items) { item in
                item.view
                    .transformPreference(SpanPreferenceKey.self) { preference in
                        preference.shrinkToLast(with: item)
                }
            }
        }
        .onPreferenceChange(SpanPreferenceKey.self) { preferences in
            print("onPreferenceChange: ")
            for preference in preferences {
                print(preference)
            }
            
            self.calculateLayout(preferences: preferences)
        }
        .overlay(Text(layout?.description ?? ""))
    }
    
    private func calculateLayout(preferences: SpanPreferenceKey.Value) {
        self.preferences = preferences
        print("onPreferenceChange: ")
        for preference in preferences {
            print(preference)
        }

        let calculatedLayout = self.arranger.arrange(preferences: preferences, columnsCount: self.columnsCount)
        self.layout = calculatedLayout
        print(calculatedLayout)
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        return Grid(columnsCount: 4) {
            Color(.blue)
            Color(.red).gridSpan(column: 1, row: 3)
            Color(.green).gridSpan(column: 3, row: 3)
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
