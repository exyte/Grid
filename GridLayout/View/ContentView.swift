//
//  ContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    enum Mode: CaseIterable {
        case first, second
    }
    
    @State var mode: Mode = .first
    
    var body: some View {
        VStack {
            Group {
                if self.mode == .first {
                    Grid(columns: [.fr(4), .const(200), .fr(1), .fr(4)], spacing: 0) {
                        HStack(spacing: 5) {
                            ForEach(0..<9, id: \.self) { _ in
                                Color(.brown)
                                    .gridSpan(column: 33)
                            }
                        }
                        .gridSpan(column: 4)
                        
                        Color(.blue)
                            .gridSpan(column: 4)
                        
                        Color(.red)
                            .gridSpan(column: 1, row: 3)
                        
                        Color(.yellow)
                        
                        Color(.purple)
                            .gridSpan(column: 2, row: 2)
                        Color(.gray)
                        Color(.green)
                            .gridSpan(column: 3, row: 3)
                        
                        Color(.orange)
                            .gridSpan(column: 1, row: 1)
                        
                    }
                } else {
                    Grid(columns: 4, spacing: 10) {
                        HStack(spacing: 5) {
                            ForEach(0..<9, id: \.self) { _ in
                                Color(.brown)
                                    .gridSpan(column: 33)
                            }
                        }
                        .gridSpan(column: 4, row: 2)
                        
                        Color(.blue)
                            .gridSpan(column: 4, row: 2)
                        
                        Color(.red)
                            .gridSpan(column: 3, row: 1)
                        
                        Color(.yellow)
                        
                        Color(.purple)
                            .gridSpan(column: 3)
                        
                        Color(.gray)
           
                        Color(.green)
                            .gridSpan(column: 2, row: 2)
                        
                        Color(.orange)
                            .gridSpan(column: 2, row: 2)
                        
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 1))
            
            Button(action: {
                self.mode = Mode.allCases[(Mode.allCases.firstIndex(of: self.mode)! + 1) % Mode.allCases.count]
            }) {
                Text("Toogle")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
