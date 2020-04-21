//
//  ContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var redColumnSpan = 1
    @State var gridSpacing = 10
    
    var body: some View {
        VStack {
            Grid(columns: 4, spacing: CGFloat(self.gridSpacing)) {
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
                    .gridSpan(column: self.redColumnSpan, row: 3)
                
                Color(.yellow)
                
                Color(.purple)
                    .gridSpan(column: 2)
                Color(.gray)
                Color(.green)
                    .gridSpan(column: 3, row: 3)
                
                Color(.orange)
                    .gridSpan(column: 3, row: 3)
                
            }
            .animation(.spring())
            
            Button(action: {
                self.redColumnSpan = self.redColumnSpan == 1 ? 4 : 1
                self.gridSpacing = self.gridSpacing == 10 ? 0 : 10
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
