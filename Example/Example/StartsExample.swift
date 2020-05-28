//
//  StartsExample.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 28.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

struct StartsExample: View {
    var body: some View {
        Grid(tracks: [.pt(50), .fr(1), .fr(1.5), .fit]) {
            ForEach(0..<6) { _ in
                ColorView(.black)
            }
            
            ColorView(.brown)
                .gridSpan(column: 3)
            
            ColorView(.blue)
                .gridSpan(column: 2)
            
            ColorView(.orange)
                .gridSpan(row: 3)
            
            ColorView(.red)
                .gridStart(row: 1)
                .gridSpan(column: 2, row: 2)
            
            ColorView(.yellow)
                .gridStart(row: 2)
            
            ColorView(.purple)
                .frame(maxWidth: 50)
                .gridStart(column: 3, row: 0)
                .gridSpan(row: 9)
            
            ColorView(.green)
                .gridSpan(column: 2, row: 3)
            
            ColorView(.cyan)
            
            ColorView(.gray)
                .gridStart(column: 2)
        }
    }
}
