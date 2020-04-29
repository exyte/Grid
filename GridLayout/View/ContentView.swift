//
//  ContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 29.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Grid(columns: 3, spacing: 5) {
            CardView().gridSpan(column: 2, row: 3)
                .frame(width: 100)
            CardView().gridSpan(column: 1, row: 2)
            CardView().gridSpan(column: 3, row: 1)
            CardView().gridSpan(column: 1, row: 1)                
        }
        .gridContentMode(.scroll)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
