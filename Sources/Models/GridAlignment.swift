//
//  GridItemAlignment.swift
//  Grid
//
//  Created by Denis Obukhov on 15.12.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

public enum GridAlignment: Hashable {
  case top, bottom, center
  case leading, trailing
  case topLeading, topTrailing
  case bottomLeading, bottomTrailing
}

extension GridAlignment {
  var swiftUIAlignment: Alignment {
    switch self {
    case .top:
      return .top
    case .bottom:
      return .bottom
    case .center:
      return .center
    case .leading:
      return .leading
    case .trailing:
      return .trailing
    case .topLeading:
      return .topLeading
    case .topTrailing:
      return .topTrailing
    case .bottomLeading:
      return .bottomLeading
    case .bottomTrailing:
      return .bottomTrailing
    }
  }
}

extension GridAlignment: CustomStringConvertible {
  public var description: String {
    switch self {
    case .top:
      return "top"
    case .bottom:
      return "bottom"
    case .center:
      return "center"
    case .leading:
      return "leading"
    case .trailing:
      return "trailing"
    case .topLeading:
      return "topLeading"
    case .topTrailing:
      return "topTrailing"
    case .bottomLeading:
      return "bottomLeading"
    case .bottomTrailing:
      return "bottomTrailing"
    }
  }
}
