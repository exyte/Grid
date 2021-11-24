//
//  GridElement.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

/// Fundamental identifiable element in a grid view
public struct GridElement: Identifiable {
  public var id: AnyHashable?
  public let view: AnyView
  let debugID = UUID()
  
  public init<T: View>(_ view: T, id: AnyHashable?) {
    self.view = AnyView(view)
    self.id = id
  }
}

extension GridElement: Equatable {
  public static func == (lhs: GridElement,
                         rhs: GridElement) -> Bool {
    return lhs.id == rhs.id
  }
}

extension GridElement: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
