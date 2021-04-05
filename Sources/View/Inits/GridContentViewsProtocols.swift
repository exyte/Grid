//
//  GridContentViewsProtocols.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

struct IdentifiedView {
  var hash: AnyHashable?
  let view: AnyView
}

protocol GridForEachRangeInt {
  var contentViews: [IdentifiedView] { get }
}

protocol GridForEachIdentifiable {
  var contentViews: [IdentifiedView] { get }
}

protocol GridForEachID {
  var contentViews: [IdentifiedView] { get }
}

protocol GridGroupContaining {
  var contentViews: [IdentifiedView] { get }
}
