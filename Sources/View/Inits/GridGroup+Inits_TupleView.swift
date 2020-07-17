//
//  GridGroup+Inits_TupleView.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//

// swiftlint:disable large_tuple

import SwiftUI

extension GridGroup {
    
    public init<C0: View>(@ViewBuilder content: () -> C0) {
        self.contentViews = content().extractContentViews()
    }
    
    public init<C0: View, C1: View>(@ViewBuilder content: () -> TupleView<(C0, C1)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        self.contentViews = views
    }
    
    public init<C0: View, C1: View, C2: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        views.append(contentsOf: content.value.2.extractContentViews())
        self.contentViews = views
    }
    
    public init<C0: View, C1: View, C2: View, C3: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        views.append(contentsOf: content.value.2.extractContentViews())
        views.append(contentsOf: content.value.3.extractContentViews())
        self.contentViews = views
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        views.append(contentsOf: content.value.2.extractContentViews())
        views.append(contentsOf: content.value.3.extractContentViews())
        views.append(contentsOf: content.value.4.extractContentViews())
        self.contentViews = views
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        views.append(contentsOf: content.value.2.extractContentViews())
        views.append(contentsOf: content.value.3.extractContentViews())
        views.append(contentsOf: content.value.4.extractContentViews())
        views.append(contentsOf: content.value.5.extractContentViews())
        self.contentViews = views
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5, C6)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        views.append(contentsOf: content.value.2.extractContentViews())
        views.append(contentsOf: content.value.3.extractContentViews())
        views.append(contentsOf: content.value.4.extractContentViews())
        views.append(contentsOf: content.value.5.extractContentViews())
        views.append(contentsOf: content.value.6.extractContentViews())
        self.contentViews = views
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        views.append(contentsOf: content.value.2.extractContentViews())
        views.append(contentsOf: content.value.3.extractContentViews())
        views.append(contentsOf: content.value.4.extractContentViews())
        views.append(contentsOf: content.value.5.extractContentViews())
        views.append(contentsOf: content.value.6.extractContentViews())
        views.append(contentsOf: content.value.7.extractContentViews())
        self.contentViews = views
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        views.append(contentsOf: content.value.2.extractContentViews())
        views.append(contentsOf: content.value.3.extractContentViews())
        views.append(contentsOf: content.value.4.extractContentViews())
        views.append(contentsOf: content.value.5.extractContentViews())
        views.append(contentsOf: content.value.6.extractContentViews())
        views.append(contentsOf: content.value.7.extractContentViews())
        views.append(contentsOf: content.value.8.extractContentViews())
        self.contentViews = views
    }
    
    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View>(@ViewBuilder content: () -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>) {
        let content = content()
        var views: [IdentifyingAnyView] = []
        views.append(contentsOf: content.value.0.extractContentViews())
        views.append(contentsOf: content.value.1.extractContentViews())
        views.append(contentsOf: content.value.2.extractContentViews())
        views.append(contentsOf: content.value.3.extractContentViews())
        views.append(contentsOf: content.value.4.extractContentViews())
        views.append(contentsOf: content.value.5.extractContentViews())
        views.append(contentsOf: content.value.6.extractContentViews())
        views.append(contentsOf: content.value.7.extractContentViews())
        views.append(contentsOf: content.value.8.extractContentViews())
        views.append(contentsOf: content.value.9.extractContentViews())
        self.contentViews = views
    }
}
