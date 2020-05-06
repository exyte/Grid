//
//  RandomizedContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct HorizontalCardView: View {

    let text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."

    var body: some View {
        HStack {
            Rectangle()
                .overlay(
                    Image("dog")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .frame(maxWidth: 200)
                .clipped()

            Text(self.text)
                .frame(maxWidth: 200)
        }
        .background(Color.red)
        .gridCellBackground { _ in
            Color(.green)
        }
    }
}

struct VerticalCardView: View {
    
    let text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor psum dolor sit amet. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
    
    var body: some View {
        VStack {
            Rectangle()
                .overlay(
                    Image("dog")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .frame(maxHeight: 200)
                .clipped()

            Text(self.text)
                
        }
        .background(Color.red)
        .gridCellBackground { _ in
            Color(.green)
        }
    }
}

struct RandomizedContentView: View {
    
    enum Mode: CaseIterable {
        case scroll, fill
    }
    
    var mode: Mode = .scroll
    
    let firstGridTracks: [TrackSize] =  4
    let secondGridTracks: [TrackSize] = 6
    
    var body: some View {
        Group {
            if self.mode == .scroll {
                Grid(0..<2, tracks: firstGridTracks, spacing: 0) { _ in
                    HorizontalCardView()
                        .gridSpan(column: 1,
                                  row: 1)
                }
                .gridContentMode(.scroll)
            } else {
                Grid(0..<6, tracks: secondGridTracks, spacing: 5) { _ in
                    HorizontalCardView()
                        .gridSpan(column: self.randomSpan(2),
                                  row: self.randomSpan(2))
                }
                .gridContentMode(.fill)
            }
        }
        .gridFlow(.rows)
        //.gridPacking(.dense)
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
