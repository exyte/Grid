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
    @State var showingCalculator = false
    @State var showingSpans = false
    @State var showingStarts = false
    @State var showingFlow = false
    @State var showingContentMode = false
    @State var showingPacking = false
    @State var showingSpacing = false

    var body: some View {
        NavigationView {
            List {
                NavigationLink("Spans", destination: SpansExample())
                NavigationLink("Starts", destination: StartsExample())
                NavigationLink("Flow", destination: FlowExample())
                NavigationLink("Content mode", destination: ContentModeExample())
                NavigationLink("Packing", destination: PackingExample())
                NavigationLink("Spacing", destination: SpacingExample())
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
