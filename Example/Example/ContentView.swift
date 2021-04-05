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
        Button("Calculator") { self.showingCalculator.toggle() }
          .sheet(isPresented: $showingCalculator) { Calculator() }
        
        Button("Spans") { self.showingSpans.toggle() }
          .sheet(isPresented: $showingSpans) { SpansExample() }
        
        Button("Starts") { self.showingStarts.toggle() }
          .sheet(isPresented: $showingStarts) { StartsExample() }
        
        Button("Flow") { self.showingFlow.toggle() }
          .sheet(isPresented: $showingFlow) { FlowExample() }
        
        Button("Content mode") { self.showingContentMode.toggle() }
          .sheet(isPresented: $showingContentMode) { ContentModeExample() }
        
        Button("Packing") { self.showingPacking.toggle() }
          .sheet(isPresented: $showingPacking) { PackingExample() }
        
        Button("Spacing") { self.showingSpacing.toggle() }
          .sheet(isPresented: $showingSpacing) { SpacingExample() }
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
