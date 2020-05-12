//
//  ContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 29.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct TextBox: View {
    let text: String
    let color: UIColor
    
    var body: some View {
        Text(self.text)
            .foregroundColor(.black)
            .fontWeight(.medium)
            .padding(5)
            .gridCellBackground { _ in
                self.background
            }
    }
    
    var borderColor: Color {
        return Color(self.color.darker() ?? .black)
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(self.color))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(self.borderColor, lineWidth: 5)
            )
    }
}

struct ContentView: View {
    var body: some View {

        Grid(tracks: [.fr(1), .fitContent, .fitContent], spacing: 10) {
            TextBox(text: self.placeholderText, color: .red)
                .gridSpan(column: 1, row: 1)
            
            TextBox(text: String(self.placeholderText.prefix(30)), color: .orange)
                .frame(maxWidth: 70)
                .gridSpan(column: 1, row: 1)
            
            TextBox(text: String(self.placeholderText.prefix(120)), color: .green)
                .frame(maxWidth: 100)
                .gridSpan(column: 1, row: 2)
            
            TextBox(text: String(self.placeholderText.prefix(160)), color: .magenta)
                .gridSpan(column: 2, row: 1)
            
            TextBox(text: String(self.placeholderText.prefix(200)), color: .cyan)
                .gridSpan(column: 3, row: 1)

        }
        .gridContentMode(.scroll)
    }
    
    //swiftlint:disable line_length
    var placeholderText = """
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat.
"""
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .gridFlow(.columns)
    }
}

private extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
