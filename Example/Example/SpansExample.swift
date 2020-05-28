//
//  SpansExample.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 28.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

struct SpansExample: View {
var body: some View {
    Grid(tracks: [.fr(1), .fit, .fit], spacing: 10) {
        VCardView(text: placeholderText(),
                  color: .red)
        
        VCardView(text: placeholderText(length: 30),
                  color: .orange)
            .frame(maxWidth: 70)
        
        VCardView(text: placeholderText(length: 120),
                  color: .green)
            .frame(maxWidth: 100)
            .gridSpan(column: 1, row: 2)
        
        VCardView(text: placeholderText(length: 160),
                  color: .magenta)
            .gridSpan(column: 2, row: 1)
        
        VCardView(text: placeholderText(length: 190),
                  color: .cyan)
            .gridSpan(column: 3, row: 1)
    }
}
}
