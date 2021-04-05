//
//  GridGroup+Inits_TupleView.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//

import SwiftUI

extension GridGroup {
  public init(@GridBuilder content: () -> ConstructionItem) {
    self.contentViews = content().contentViews
  }
}
