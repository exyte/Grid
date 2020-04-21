//
//  Grid+Inits.swift
//  GridLayout
//
//  Created by Denis Obukhov on 18.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

// swiftlint:disable large_tuple line_length

import SwiftUI

extension Grid {
    public init<C0: View, C1: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1))]
    }
    
    public init<C0: View, C1: View, C2: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1)),
                      GridItem(AnyView(content().value.2))]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1)),
                      GridItem(AnyView(content().value.2)),
                      GridItem(AnyView(content().value.3))]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1)),
                      GridItem(AnyView(content().value.2)),
                      GridItem(AnyView(content().value.3)),
                      GridItem(AnyView(content().value.4))]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1)),
                      GridItem(AnyView(content().value.2)),
                      GridItem(AnyView(content().value.3)),
                      GridItem(AnyView(content().value.4)),
                      GridItem(AnyView(content().value.5))]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1)),
                      GridItem(AnyView(content().value.2)),
                      GridItem(AnyView(content().value.3)),
                      GridItem(AnyView(content().value.4)),
                      GridItem(AnyView(content().value.5)),
                      GridItem(AnyView(content().value.6))]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1)),
                      GridItem(AnyView(content().value.2)),
                      GridItem(AnyView(content().value.3)),
                      GridItem(AnyView(content().value.4)),
                      GridItem(AnyView(content().value.5)),
                      GridItem(AnyView(content().value.6)),
                      GridItem(AnyView(content().value.7))]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1)),
                      GridItem(AnyView(content().value.2)),
                      GridItem(AnyView(content().value.3)),
                      GridItem(AnyView(content().value.4)),
                      GridItem(AnyView(content().value.5)),
                      GridItem(AnyView(content().value.6)),
                      GridItem(AnyView(content().value.7)),
                      GridItem(AnyView(content().value.8))]
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View>(columns: Int, spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        self.columns = columns
        self.spacing = spacing
        self.items = [GridItem(AnyView(content().value.0)),
                      GridItem(AnyView(content().value.1)),
                      GridItem(AnyView(content().value.2)),
                      GridItem(AnyView(content().value.3)),
                      GridItem(AnyView(content().value.4)),
                      GridItem(AnyView(content().value.5)),
                      GridItem(AnyView(content().value.6)),
                      GridItem(AnyView(content().value.7)),
                      GridItem(AnyView(content().value.8)),
                      GridItem(AnyView(content().value.9))]
    }
}
