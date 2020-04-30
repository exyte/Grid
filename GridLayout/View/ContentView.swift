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
        Grid(tracks: 2, spacing: 0) {
            HorizontalCardView()
                .overlay(Text("1"))
                .gridSpan(column: 1, row: 2)
            HorizontalCardView()
                .gridSpan(column: 1, row: 2)
                .overlay(Text("2"))
            
            HorizontalCardView()

        }
        .gridContentMode(.fill)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .gridFlow(.columns)
    }
}
