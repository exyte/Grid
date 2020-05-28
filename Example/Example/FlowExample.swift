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
            if self.flow == .rows {
                Button(action: { self.flow = .columns }) {
                    Text("Flow: ROWS")
                }
            } else {
                Button(action: { self.flow = .rows }) {
                    Text("Flow: COLUMNS")
                }
            }
            
            Grid(0..<15, tracks: 5, flow: self.flow, spacing: 5) {
                ColorView($0.isMultiple(of: 2) ? .black : .orange)
                    .overlay(
                        Text(String($0))
                            .font(.system(size: 35))
                            .foregroundColor(.white)
                )
            }
            .animation(.default)
        }
    }
}

struct FlowExample_Previews: PreviewProvider {
    static var previews: some View {
        FlowExample()
    }
}
