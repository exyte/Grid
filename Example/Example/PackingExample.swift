//
//  PackingExample.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 27.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

struct PackingExample: View {
  
  @State var gridPacking = GridPacking.sparse
  
  private var packingPicker: some View {
    Picker("Packing", selection: $gridPacking) {
      withAnimation {
        ForEach([GridPacking.sparse, GridPacking.dense], id: \.self) {
          Text($0 == .sparse ? "SPARSE" : "DENSE")
            .tag($0)
        }
      }
    }
    .pickerStyle(SegmentedPickerStyle())
  }
  
  var body: some View {
    VStack {
      self.packingPicker
      
      Grid(tracks: 4) {
        ColorView(.red)
        
        ColorView(.black)
          .gridSpan(column: 4)
        
        ColorView(.purple)
        
        ColorView(.orange)
        ColorView(.green)
      }
      .gridPacking(self.gridPacking)
      .gridAnimation(.default)
    }
  }
}

struct PackingExample_Previews: PreviewProvider {
  static var previews: some View {
    PackingExample()
  }
}
