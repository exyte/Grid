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
        Grid(columns: [.auto, .auto, .auto], spacing: 0) {
            CardView()
                .gridSpan(column: 2, row: 1)
                .frame(width: 100)
                
            CardView()
                .frame(width: 200)
            CardView()
                .frame(width: 150)
            .gridSpan(column: 2, row: 1)
            CardView()
                .frame(width: 130)
        }
        .gridContentMode(.scroll)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
