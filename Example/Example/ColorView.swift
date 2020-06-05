//
//  ColorView.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 28.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct ColorView: View {
    
    let color: UIColor
    
    init(_ color: UIColor) {
        self.color = color
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(
                LinearGradient(gradient:
                    Gradient(colors:
                        [Color(self.color.lighter()),
                         Color(self.color.darker())]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
        )
        
    }
}
