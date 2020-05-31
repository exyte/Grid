//
//  PackingExample.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 27.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

struct SpacingExample: View {

    @State var vSpacing: CGFloat = 0
    @State var hSpacing: CGFloat = 0
    
    var body: some View {
        VStack {
            self.sliders
//            
//            Grid(tracks: 3, spacing: [hSpacing, vSpacing]) {
//                ForEach(0..<21) {
//                    //Inner image used to measure size
//                    self.image
//                        .aspectRatio(contentMode: .fit)
//                        .opacity(0)
//                        .gridSpan(column: max(1, $0 % 4))
//                        .gridCellOverlay {
//                            //This one is to display
//                            self.image
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: $0?.width, height: $0?.height)
//                                .cornerRadius(5)
//                                .clipped()
//                                .shadow(color: self.shadowColor, radius: 10, x: 0, y: 0)
//                    }
//                }
//            }
//            .background(self.backgroundColor)
//            .gridContentMode(.scroll)
//            .gridPacking(.dense)
        }
    }
    
    var sliders: some View {
        VStack(spacing: 10) {
            HStack {
                Text("hSpace: ")
                Slider(value: $hSpacing, in: 0...50, step: 1)
            }
            HStack {
                Text("vSpace: ")
                Slider(value: $vSpacing, in: 0...50, step: 1)
            }
        }
        .padding()
        .background(Color.white)
    }
    
    var image: Image {
        Image("dog")
            .resizable()
    }
    
    var shadowColor: Color {
        Color.black.opacity(Double(max(self.vSpacing, self.hSpacing)) / 20)
    }
    
    var backgroundColor: Color {
        Color.black.opacity(1 - Double(max(self.vSpacing, self.hSpacing)) / 20)
    }
}

struct SpacingExample_Previews: PreviewProvider {
    static var previews: some View {
        SpacingExample()
    }
}
