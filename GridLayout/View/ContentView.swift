//
//  ContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Grid(columnsCount: 4) {
            Color(.blue).gridSpan(column: 4)
            Color(.red).gridSpan(row: 3)
            Color(.yellow)
            Color(.purple).gridSpan(column: 2)
            Color(.green).gridSpan(column: 3, row: 3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
