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
        Grid(tracks: [.const(50), .fr(1), .fr(1.5), .fitContent], spacing: [5, 10]) {
            
            ForEach(0..<6) { _ in
                Color.black
            }
            
            Color(.brown)
                .gridSpan(column: 3)
            
            Color(.blue)
                .gridSpan(column: 2)
            
            Color(.red)
                .gridStart(column: 5, row: 1)
                .gridSpan(column: 2, row: 2)
            
            Color(.yellow)
                .gridStart(row: 2)
            
            Color(.purple)
                .frame(maxWidth: 50)
                .gridStart(column: 3, row: 0)
                .gridSpan(row: 10)
            
            Color(.green)
                .gridSpan(column: 2, row: 3)
            
            Color(.orange)
                .gridSpan(row: 3)
            
            Color(.gray)
                .gridStart(column: 2)
            
            GridGroup {
                Color(.cyan)
                
                Color(.magenta)
            }
        }
        .gridPacking(.dense)
        .gridFlow(.rows)
    }
    
    //swiftlint:disable line_length
    var placeholderText = """
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat.
"""
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .gridFlow(.rows)
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
