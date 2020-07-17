//
//  GridContentViewsProtocols.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

typealias IdentifyingAnyView = (hash: AnyHashable?, view: AnyView)

protocol GridForEachRangeInt {
    var contentViews: [IdentifyingAnyView] { get }
}

protocol GridForEachIdentifiable {
    var contentViews: [IdentifyingAnyView] { get }
}

protocol GridForEachID {
    var contentViews: [IdentifyingAnyView] { get }
}

protocol GridGroupContaining {
    var contentViews: [IdentifyingAnyView] { get }
}
