//
//  ColorView.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 28.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct ColorView: View {

    var color: GridColor
    var cornerRadius: CGFloat = 5
    var debugSize: Bool = false

    init(_ color: GridColor, cornerRadius: CGFloat = 5, debugSize: Bool = false) {
        self.color = color
        self.cornerRadius = cornerRadius
        self.debugSize = debugSize
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color(color.lighter()), Color(color.darker())]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                if debugSize {
                    GeometryReader { geo in
                        Text("\(Int(geo.size.width))×\(Int(geo.size.height))")
                            .font(.system(size: 9))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
    }
}
