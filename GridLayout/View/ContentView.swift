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

        Grid(tracks: 3) { 
            ForEach(0..<2) { _ in
                VCardView()
            }
            
            VCardView()

            ForEach(0..<3) { _ in
                VCardView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .gridFlow(.columns)
    }
}
