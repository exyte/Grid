//
//  GridGroup+Inits_TupleView.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//

// swiftlint:disable large_tuple

import SwiftUI

extension GridGroup {

    public init(@AnyViewBuilder content: () -> ConstructionItem) {
        self.contentViews = content().contentViews
    }

}
