//
//  FlowExample.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 28.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

struct FlowExample: View {
  @State var flow: GridFlow = .rows
  
  var body: some View {
    VStack {
      self.flowPicker
      
      Grid(0..<15, tracks: 5, flow: self.flow, spacing: 5) {
        ColorView($0.isMultiple(of: 2) ? .black : .orange)
          .overlay(
            Text(String($0))
              .font(.system(size: 35))
              .foregroundColor(.white)
          )
      }
      .gridAnimation(.default)
    }
  }
  
  private var flowPicker: some View {
    Picker("Flow", selection: $flow) {
      withAnimation {
        ForEach([GridFlow.rows, GridFlow.columns], id: \.self) {
          Text($0 == .rows ? "ROWS" : "COLUMNS")
            .tag($0)
        }
      }
    }
    .pickerStyle(SegmentedPickerStyle())
  }
}

struct FlowExample_Previews: PreviewProvider {
  static var previews: some View {
    FlowExample()
  }
}
