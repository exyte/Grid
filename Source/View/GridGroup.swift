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
    var contentViews: [AnyView]
    
    public var body: some View {
        EmptyView()
    }
}

extension GridGroup {
    public init<C0: View, C1: View>(@ViewBuilder content: () -> TupleView<(C0, C1)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1)
        ]
    }
    
    public init<C0: View, C1: View, C2: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1),
             AnyView(content.value.2)
        ]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1),
             AnyView(content.value.2),
             AnyView(content.value.3)
        ]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1),
             AnyView(content.value.2),
             AnyView(content.value.3),
             AnyView(content.value.4)
        ]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1),
             AnyView(content.value.2),
             AnyView(content.value.3),
             AnyView(content.value.4),
             AnyView(content.value.5)
        ]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5, C6)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1),
             AnyView(content.value.2),
             AnyView(content.value.3),
             AnyView(content.value.4),
             AnyView(content.value.5),
             AnyView(content.value.6)
        ]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1),
             AnyView(content.value.2),
             AnyView(content.value.3),
             AnyView(content.value.4),
             AnyView(content.value.5),
             AnyView(content.value.6),
             AnyView(content.value.7)
        ]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1),
             AnyView(content.value.2),
             AnyView(content.value.3),
             AnyView(content.value.4),
             AnyView(content.value.5),
             AnyView(content.value.6),
             AnyView(content.value.7),
             AnyView(content.value.8)
        ]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>) {
        let content = content()
        self.contentViews =
            [AnyView(content.value.0),
             AnyView(content.value.1),
             AnyView(content.value.2),
             AnyView(content.value.3),
             AnyView(content.value.4),
             AnyView(content.value.5),
             AnyView(content.value.6),
             AnyView(content.value.7),
             AnyView(content.value.8),
             AnyView(content.value.9)
        ]
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
