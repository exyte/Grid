//
//  Color+brightness.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 28.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

#if os(iOS) || os(watchOS) || os(tvOS)

import UIKit
typealias GridColor = UIColor

#else

import AppKit
typealias GridColor = NSColor

#endif

extension GridColor {
  func lighter(by percentage: CGFloat = 30.0) -> GridColor {
    return self.adjust(by: abs(percentage) )
  }
  
  func darker(by percentage: CGFloat = 30.0) -> GridColor {
    return self.adjust(by: -1 * abs(percentage) )
  }
  
  func adjust(by percentage: CGFloat = 30.0) -> GridColor {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    #else
    self.usingColorSpace(.deviceRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    #endif
    
    return GridColor(red: min(red + percentage / 100, 1.0),
                     green: min(green + percentage / 100, 1.0),
                     blue: min(blue + percentage / 100, 1.0),
                     alpha: alpha)
  }
  
  static var random: GridColor {
    GridColor(hue: CGFloat(arc4random_uniform(255)) / 255.0, saturation: 1, brightness: 1, alpha: 1)
  }
}
