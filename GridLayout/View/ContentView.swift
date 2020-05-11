//
//  ContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 29.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct Foo: Identifiable {
    let id: Int
}

struct ContentView: View {
    var body: some View {

        Grid(tracks: [.fr(1), .fitContent, .fitContent], spacing: 0) {
                Text("1Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Lorem ipsum dolor sit amet,"
                    + " consectetuer adipiscing elit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.")
//                    .frame(maxWidth: 88)
                    .gridSpan(column: 1, row: 1)
                    .background(Color.red)
                    .gridCellBackground { _ in
                        Color.yellow.border(Color.black, width: 1)
                    }

                Text("2Lorem ipsum dolor sit amet, consectetuer adipiscing elit.")
                    .frame(maxWidth: 42)
                    .gridSpan(column: 1, row: 1)
                    .background(Color.blue)
                    .gridCellBackground { _ in
                        Color.yellow.border(Color.black, width: 1)
                    }

                Text("3Lorem ipsum dolor sit amet, consectetuer adipiscing elit.")
                    .frame(maxWidth: 69)
                    .gridSpan(column: 1, row: 1)
                    .background(Color.green)
                    .gridCellBackground { _ in
                        Color.yellow.border(Color.black, width: 1)
                    }
            
                Text("4Lorem Lorem ipsum dolor sit amet, co nsectetuer adipiscing elit. Lorem ipsum dolor sit amet")
//                    .frame(maxWidth: 69)
                    .gridSpan(column: 2, row: 1)
                    .background(Color.orange)
                    .gridCellBackground { _ in
                        Color.yellow.border(Color.black, width: 1)
                    }
            
            Text("5Lorem ipsum dolor sit amet, consectetuer adipiscing elit. h h h h h hkkkk k k k")
                .frame(maxWidth: 100)
                .gridSpan(column: 1, row: 1)
                .background(Color.purple)
                .gridCellBackground { _ in
                    Color.yellow.border(Color.black, width: 1)
                }
                .gridSpan(column: 1, row: 1)
        }
        .gridContentMode(.scroll)
 
 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .gridFlow(.columns)
    }
}
