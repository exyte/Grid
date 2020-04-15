//
//  ContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    let sizeW: CGFloat = 50
    let sizeH: CGFloat = 70
    let spacing: CGFloat = 0
    @State var gaps: CGFloat = 15
    
    let count = 4
    lazy var totalWidth: CGFloat = CGFloat(count) * (sizeW + gaps) + 100
    lazy var totalHeight: CGFloat = CGFloat(count) * (sizeH + gaps)
    
    func rectangle(w: Int, h: Int) -> some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(randomColor(index: w + h * 10))
                    .frame(width: CGFloat(w) * (sizeW) + (CGFloat(w) - 1) * gaps,
                           height: CGFloat(h) * (sizeH) + (CGFloat(h) - 1) * gaps,
                           alignment: .topLeading)
                    .padding(gaps / 2)
            }
        }


    }
    
    func randomColor(index: Int) -> Color {
        srand48(index)
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return Color(color)
    }
    
    var body: some View {
        /*
         
         a b c d
         e e c f
         e e g g
         h h h j
         
         */

        return VStack {
            GeometryReader { geometry in
                VStack(spacing: self.spacing) {
                    HStack(spacing: self.spacing) {
                        VStack(spacing: self.spacing) {
                            HStack(spacing: self.spacing) {
                                self.rectangle(w: 1, h: 1)
                                self.rectangle(w: 1, h: 1)
                            }
                            self.rectangle(w: 2, h: 2)
                        }
                        
                        VStack(spacing: self.spacing) {
                            HStack(spacing: self.spacing) {
                                self.rectangle(w: 1, h: 2)
                                VStack(spacing: self.spacing) {
                                    self.rectangle(w: 1, h: 1)
                                    self.rectangle(w: 1, h: 1)
                                }
                            }
                            
                            self.rectangle(w: 2, h: 1)
                        }

                    }
                    HStack(spacing: self.spacing) {
                        self.rectangle(w: 3, h: 1)

                        self.rectangle(w: 1, h: 1)
                    }
                }
                .background(Color.black.opacity(0.3))
            }
            
            Slider(value: $gaps, in: 0...50)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
