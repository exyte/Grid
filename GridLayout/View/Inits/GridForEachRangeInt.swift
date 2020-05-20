//
//  GridViewsContaining.swift
//  GridLayout
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

protocol GridForEachRangeInt {
    var contentViews: [AnyView] { get }
}

protocol GridForEachIdentifiable {
    var contentViews: [AnyView] { get }
}

protocol GridForEachID {
    var contentViews: [AnyView] { get }
}
