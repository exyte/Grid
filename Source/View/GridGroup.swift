//
//  GridGroup.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 18.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

// swiftlint:disable large_tuple

import SwiftUI

protocol GridGroupContaining {
    var contentViews: [AnyView] { get }
}

public struct GridGroup: View, GridGroupContaining {
    
    public static var empty = GridGroup(contentViews: [])
    
    var contentViews: [AnyView]
    
    public var body: some View {
        EmptyView()
    }
}

#if DEBUG

// To be available on preview canvas

extension ModifiedContent: GridGroupContaining where Content: GridGroupContaining, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
    var contentViews: [AnyView] {
        return self.content.contentViews
    }
}

#endif
