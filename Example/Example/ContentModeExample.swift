//
//  ContentModeExample.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 28.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

struct ContentModeExample: View {
  private struct Model: Hashable {
    let text: String
    let span: GridSpan
    let color = GridColor.random.lighter(by: 50)
  }
  
  @State var contentMode: GridContentMode = .contentFit
  
  var body: some View {
    VStack {
      self.modesPicker
      
      if self.contentMode == .contentFit {
        ScrollView {
          myView
        }
      } else {
        myView
      }
    }
  }
  
  var myView: some View {
      Grid(models, id: \.self, tracks: 3) {
        VCardView(text: $0.text, color: $0.color)
          .gridSpan($0.span)
      }
      .gridContentMode(self.contentMode)
      .gridFlow(.rows)
      .background(Color.blue)
  }
  
  private let models: [Model] = [
    Model(text: placeholderText(length: 30), span: [1, 1]),
    Model(text: placeholderText(length: 50), span: [1, 1]),
    Model(text: placeholderText(length: 20), span: [1, 1]),
    Model(text: placeholderText(length: 100), span: [2, 1]),
    Model(text: placeholderText(length: 150), span: [1, 1]),
    Model(text: placeholderText(length: 75), span: [1, 1]),
    Model(text: placeholderText(length: 155), span: [1, 1]),
    Model(text: placeholderText(length: 150), span: [1, 2]),
    Model(text: placeholderText(length: 160), span: [2, 1]),
    Model(text: placeholderText(length: 300), span: [3, 1])
  ]
  
  private var modesPicker: some View {
    Picker("Mode", selection: $contentMode) {
      ForEach([GridContentMode.contentFit, GridContentMode.scroll, GridContentMode.fill], id: \.self) {
        switch($0) {
        case .contentFit: Text("ContentFit").tag($0)
        case .scroll: Text("Scroll").tag($0)
        case .fill: Text("Fill").tag($0)
        }
      }
    }
    .pickerStyle(SegmentedPickerStyle())
  }
}

struct ContentModeExample_Previews: PreviewProvider {
  static var previews: some View {
    ContentModeExample()
  }
}
