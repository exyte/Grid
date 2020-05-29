//
//  ContentView.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 29.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Calculator()) {
                    Text("Calculator")
                }
                NavigationLink(destination: SpansExample()) {
                    Text("Spans")
                }
                NavigationLink(destination: StartsExample()) {
                    Text("Starts")
                }
                NavigationLink(destination: FlowExample()) {
                    Text("Flow")
                }
                NavigationLink(destination: ContentModeExample()) {
                    Text("Content mode")
                }
                NavigationLink(destination: PackingExample()) {
                    Text("Packing")
                }
                NavigationLink(destination: SpacingExample()) {
                    Text("Spacing")
                }
            }
            .navigationBarTitle(Text("ExyteGrid"), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
