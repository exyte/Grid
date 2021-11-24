//
//  GridContentViewsProtocols.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

protocol GridForEachRangeInt {
  var contentViews: [GridElement] { get }
}

protocol GridForEachIdentifiable {
  var contentViews: [GridElement] { get }
}

protocol GridForEachID {
  var contentViews: [GridElement] { get }
}

protocol GridGroupContaining {
  var contentViews: [GridElement] { get }
}
