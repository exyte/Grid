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
        Grid(tracks: 3) { 
            VCardView()

            ForEach(0..<4) { _ in
                VCardView()
            }

            ForEach([Foo(id: 1), Foo(id: 2)]) { _ in
                VCardView()
            }
            
            ForEach([1, 2], id: \.self) { _ in
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
