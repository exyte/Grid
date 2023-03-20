//
//  CardViews.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 28.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct VCardView: View {
    let text: String
    let color: GridColor

    var body: some View {
        VStack {
            Image("dog")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5)
                .frame(minHeight: 25)
            
            Text(self.text)
                .layoutPriority(.greatestFiniteMagnitude)
                .minimumScaleFactor(0.5)
        }
        .padding(5)
        .gridCellBackground { _ in
            ColorView(self.color)
        }
        .gridCellOverlay { _ in
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(Color(self.color.darker()),
                              lineWidth: 3)
        }
    }
}

struct HCardView: View {
    let text: String
    let color: GridColor
    
    var body: some View {
        HStack {
            Image("dog")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5)
                .frame(minHeight: 25)
            
            Text(self.text)
                .layoutPriority(.greatestFiniteMagnitude)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: 200)
        }
        .padding(5)
        .gridCellBackground { _ in
            ColorView(self.color)
        }
        .gridCellOverlay { _ in
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(Color(self.color.darker()),
                              lineWidth: 3)
        }
    }
}
