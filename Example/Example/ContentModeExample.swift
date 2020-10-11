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
    
    @State var contentMode: GridContentMode = .scroll

    var body: some View {
        VStack {
            self.modesPicker
            
            Grid(models, id: \.self, tracks: 3) {
                VCardView(text: $0.text, color: $0.color)
                    .gridSpan($0.span)
            }
            .gridContentMode(self.contentMode)
            .gridFlow(.rows)
        }
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
            ForEach([GridContentMode.scroll, GridContentMode.fill], id: \.self) {
                Text($0 == .scroll ? "Scroll" : "Fill")
                    .tag($0)
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
