//
//  RandomizedContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    let text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor psum dolor sit amet."
    
    var body: some View {
        VStack {
            Image("dog")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0,
                       minHeight: 0,
                      maxHeight: 200
                )
                .clipped()
            
            Text(self.text)
        }
        .gridCellBackground { _ in
            Color(.green)
        }
        .background(Color.red)
    }
}

struct RandomizedContentView: View {
    
    enum Mode: CaseIterable {
        case scroll, fill
    }
    
    var mode: Mode = .scroll
    
    let firstGridColumns: [TrackSize] = [.fr(1), .fr(2), .const(200)]
    let secondGridColumns: [TrackSize] = 6
    
    var body: some View {
        Group {
            if self.mode == .scroll {
                Grid(0..<40, columns: firstGridColumns, spacing: 5) { _ in
                    CardView()
                        .gridSpan(column: self.randomSpan(self.firstGridColumns.count),
                                  row: self.randomSpan(3))
                }
                .gridContentMode(.scroll)
            } else {
                Grid(0..<6, columns: secondGridColumns, spacing: 5) { _ in
                    CardView()
                        .gridSpan(column: self.randomSpan(self.secondGridColumns.count),
                                  row: self.randomSpan(3))
                }
                .gridContentMode(.fill)
            }
        }
    }
    
    func randomSpan(_ max: Int) -> Int {
        1 + Int(arc4random_uniform(UInt32(max)))
    }
}

struct RandomizedContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RandomizedContentView(mode: .scroll)
            RandomizedContentView(mode: .fill)
        }
    }
}
