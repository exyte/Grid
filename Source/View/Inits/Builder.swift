//
//  Builder.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//

import SwiftUI

@_functionBuilder
public struct AnyViewBuilder {
    public static func buildBlock() -> GridGroup {
        return GridGroup(contentViews: [])
    }
    
    public static func buildBlock<C0: View>(_ c0: C0) -> GridGroup {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        return GridGroup(contentViews: views)
    }
    
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> GridGroup where C0 : View, C1 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        return GridGroup(contentViews: views)
    }
    
    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> GridGroup where C0 : View, C1 : View, C2 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        views.append(contentsOf: c2.extractContentViews())
        return GridGroup(contentViews: views)
    }
    
    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> GridGroup where C0 : View, C1 : View, C2 : View, C3 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        views.append(contentsOf: c2.extractContentViews())
        views.append(contentsOf: c3.extractContentViews())
        return GridGroup(contentViews: views)
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> GridGroup where C0 : View, C1 : View, C2 : View, C3 : View, C4 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        views.append(contentsOf: c2.extractContentViews())
        views.append(contentsOf: c3.extractContentViews())
        views.append(contentsOf: c4.extractContentViews())
        return GridGroup(contentViews: views)
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> GridGroup where C0 : View, C1 : View, C2 : View, C3 : View, C4 : View, C5 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        views.append(contentsOf: c2.extractContentViews())
        views.append(contentsOf: c3.extractContentViews())
        views.append(contentsOf: c4.extractContentViews())
        views.append(contentsOf: c5.extractContentViews())
        return GridGroup(contentViews: views)
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> GridGroup where C0 : View, C1 : View, C2 : View, C3 : View, C4 : View, C5 : View, C6 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        views.append(contentsOf: c2.extractContentViews())
        views.append(contentsOf: c3.extractContentViews())
        views.append(contentsOf: c4.extractContentViews())
        views.append(contentsOf: c5.extractContentViews())
        views.append(contentsOf: c6.extractContentViews())
        return GridGroup(contentViews: views)
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> GridGroup where C0 : View, C1 : View, C2 : View, C3 : View, C4 : View, C5 : View, C6 : View, C7 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        views.append(contentsOf: c2.extractContentViews())
        views.append(contentsOf: c3.extractContentViews())
        views.append(contentsOf: c4.extractContentViews())
        views.append(contentsOf: c5.extractContentViews())
        views.append(contentsOf: c6.extractContentViews())
        views.append(contentsOf: c7.extractContentViews())
        return GridGroup(contentViews: views)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> GridGroup where C0 : View, C1 : View, C2 : View, C3 : View, C4 : View, C5 : View, C6 : View, C7 : View, C8 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        views.append(contentsOf: c2.extractContentViews())
        views.append(contentsOf: c3.extractContentViews())
        views.append(contentsOf: c4.extractContentViews())
        views.append(contentsOf: c5.extractContentViews())
        views.append(contentsOf: c6.extractContentViews())
        views.append(contentsOf: c7.extractContentViews())
        views.append(contentsOf: c8.extractContentViews())
        return GridGroup(contentViews: views)
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> GridGroup where C0 : View, C1 : View, C2 : View, C3 : View, C4 : View, C5 : View, C6 : View, C7 : View, C8 : View, C9 : View {
        var views: [AnyView] = []
        views.append(contentsOf: c0.extractContentViews())
        views.append(contentsOf: c1.extractContentViews())
        views.append(contentsOf: c2.extractContentViews())
        views.append(contentsOf: c3.extractContentViews())
        views.append(contentsOf: c4.extractContentViews())
        views.append(contentsOf: c5.extractContentViews())
        views.append(contentsOf: c6.extractContentViews())
        views.append(contentsOf: c7.extractContentViews())
        views.append(contentsOf: c8.extractContentViews())
        views.append(contentsOf: c9.extractContentViews())
        return GridGroup(contentViews: views)
    }

    public static func buildEither(first: GridGroup) -> GridGroup {
        GridGroup(contentViews:
            first.contentViews.map { AnyView($0.id(UUID()))  }
        )
    }
    
    public static func buildEither(second: GridGroup) -> GridGroup {
        GridGroup(contentViews:
            second.contentViews.map { AnyView($0.id(UUID()))  }
        )
    }

    public static func buildIf<T: View>(_ content: T?) -> GridGroup {
        let cccc = content
        return GridGroup(contentViews: content?.extractContentViews() ?? [])
    }
    
    public static func buildOptional<T: View>(_ view: T?) -> GridGroup {
        if let view = view {
            return GridGroup(contentViews: view.extractContentViews())
        }
        return GridGroup(contentViews: [])
    }
}
