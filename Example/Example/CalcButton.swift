//
//  CalcButton.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 27.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

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
    if case .function = self.operation {
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
