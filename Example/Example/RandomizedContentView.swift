//
//  RandomizedContentView.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

//struct HCardView: View {
//
//    var body: some View {
//        HStack {
//            Rectangle()
//                .overlay(
//                    Image("dog")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                )
//                .frame(maxWidth: 100)
//                .clipped()
//
//            Text(randomText())
//                .frame(maxWidth: 100)
//        }
//        .background(Color.red)
//        .frame(maxHeight: 150)
//        .clipped()
//        .gridCellBackground { _ in
//            Color(.green)
//        }
//    }
//}
//
//struct VCardView: View {
//
//    var body: some View {
//        VStack {
//            Rectangle()
//                .overlay(
//                    Image("dog")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                )
//                .frame(maxHeight: 200)
//                .clipped()
//
//            Text(randomText())
//
//        }
//        .background(Color.red)
//        .frame(maxWidth: 100)
//        .clipped()
//        .gridCellBackground { _ in
//            Color(.green)
//        }
//    }
//}



struct RandomizedContentView: View {
    
    enum Mode: CaseIterable {
        case scroll, fill
    }
    
    var mode: Mode = .fill
    
    let firstGridTracks: [GridTrack] = [.fit, .fit, .fr(1)]
    let secondGridTracks: [GridTrack] = 6
    
    var body: some View {
        EmptyView()
//        Group {
//            if self.mode == .scroll {
//                Grid(0..<20, tracks: firstGridTracks, spacing: 20) { _ in
//                    VCardView()
//                        .gridSpan(column: self.randomSpan(2),
//                                  row: self.randomSpan(2))
//                }
//                .gridContentMode(.scroll)
//            } else {
//                Grid(0..<6, tracks: secondGridTracks, spacing: 4) { _ in
//                    VCardView()
//                        .gridSpan(column: self.randomSpan(2),
//                                  row: self.randomSpan(2))
//                }
//                .gridContentMode(.fill)
//            }
//        }
//        .gridFlow(.rows)
//        .gridPacking(.sparse)
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
