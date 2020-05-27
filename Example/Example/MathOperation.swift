//
//  MathOperation.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 27.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import Foundation

enum MathOperation: Hashable {
    case digit(Int)
    case clear, sign, percent, equal, point
    case divide, multiply, add, substract
    case function(Int)
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
        case .function(let number):
            return "f\(number + 1)"
        }
    }
}
