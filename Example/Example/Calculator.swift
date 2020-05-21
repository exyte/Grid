//
//  Calculator.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 20.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

enum MathOperation: Hashable {
    case digit(Int)
    case clear, sign, percent, equal, point
    case divide, multiply, add, substract
    case function
}

extension MathOperation: CustomStringConvertible {
    var description: String {
        switch self {
        case .digit(let digit):
            return String(digit)
        case .clear:
            return "C"
        case .sign:
            return "±"
        case .percent:
            return "%"
        case .equal:
            return "="
        case .point:
            return "."
        case .divide:
            return "÷"
        case .multiply:
            return "×"
        case .add:
            return "+"
        case .substract:
            return "−"
        case .function:
            return "f(x)"
        }
    }
}

struct CalcButton: View {
    let operation: MathOperation

    init(_ operation: MathOperation) {
        self.operation = operation
    }

    var body: some View {
        Button(action: {}) {
            Capsule()
                .fill(self.fillColor)
                .overlay(
                    Text(self.operation.description)
                        .font(.custom("PingFang TC", size: 32))
                        .fontWeight(.regular)
                        .minimumScaleFactor(0.01)
                        .foregroundColor(self.textColor)
                        .padding(10)
                )
        }
    }
    
    var fillColor: Color {
        if [.divide, .multiply, .substract, .add, .equal].contains(self.operation) {
            return Color(hex: "#fca00b")
        }
        if [.clear, .sign, .percent].contains(self.operation) {
            return Color(hex: "#a4a5a6")
        }
        if self.operation == .function {
            return Color(hex: "#202122")
        }
        return Color(hex: "#323334")
    }
    
    var textColor: Color {
        if [.clear, .sign, .percent].contains(self.operation) {
            return Color.black
        }
        return Color.white
    }
}

struct Calculator: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

    var isPortrait: Bool {
        let result = verticalSizeClass == .regular && horizontalSizeClass == .compact
        return result
    }
    
    var landscapeButtons: [MathOperation] {
        self.isPortrait ? [] : (0..<30).map { _ in .function }
    }
    
    var mainArithmeticButtons: [MathOperation] {
        [.divide, .multiply, .substract, .add, .equal]
    }
    
    var tracks: [GridTrack] {
        self.isPortrait ? 4 : 10
    }
    
    var digitButtons: [MathOperation] {
        (1..<10).map { .digit($0) }
    }
    
    func proportionalSize(geometry: GeometryProxy) -> CGSize {
        let height: CGFloat
        if self.isPortrait {
            height = geometry.size.width * 5 / 4
        } else {
            height = geometry.size.width * 4.8 / 10
        }
        return CGSize(width: geometry.size.width,
                      height: height)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing, spacing: 0) {
                Spacer()
                Text("565 626")
                    .foregroundColor(.white)
                    .font(.custom("PingFang TC", size: 90))
                    .fontWeight(.light)
                    .minimumScaleFactor(0.01)
                
                Grid(tracks: self.tracks, spacing: 10) {
                    GridGroup {
                        CalcButton(.clear)
                        CalcButton(.sign)
                        CalcButton(.percent)
                    }
  
                    ForEach(self.digitButtons, id: \.self) {
                        CalcButton($0)
                    }

                    CalcButton(.digit(0)).gridSpan(column: 2)
                    
                    CalcButton(.point)
                    
                    ForEach(self.mainArithmeticButtons, id: \.self) {
                        CalcButton($0).gridStart(column: self.tracks.count - 1)
                    }
                    
                    ForEach(0..<self.landscapeButtons.count, id: \.self) {
                        CalcButton(self.landscapeButtons[$0])
                            .gridStart(row: $0 % 5)
                    }
                }
                .gridContentMode(.fill)
                .frame(width: self.proportionalSize(geometry: geometry).width,
                       height: self.proportionalSize(geometry: geometry).height)
                .background(Color.black)
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        Calculator()
            .environment(\.verticalSizeClass, .regular)
            .environment(\.horizontalSizeClass, .compact)
    }
}
