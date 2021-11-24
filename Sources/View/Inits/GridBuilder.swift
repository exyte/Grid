//
//  Builder.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 10.08.2020.
//

// swiftlint:disable function_parameter_count identifier_name line_length

import SwiftUI

public struct GridBuilderResult: View {
  public var body = EmptyView()
  var contentViews: [GridElement]
}

@resultBuilder
public struct GridBuilder {
  public static func buildBlock() -> GridBuilderResult {
    return GridBuilderResult(contentViews: [])
  }
  
  public static func buildBlock<C0: View>(_ content: C0) -> GridBuilderResult {
    var views: [GridElement] = []
    views.append(contentsOf: content.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> GridBuilderResult where C0: View, C1: View {
    var views: [GridElement] = []
    views.append(contentsOf: c0.extractContentViews())
    views.append(contentsOf: c1.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> GridBuilderResult where C0: View, C1: View, C2: View {
    var views: [GridElement] = []
    views.append(contentsOf: c0.extractContentViews())
    views.append(contentsOf: c1.extractContentViews())
    views.append(contentsOf: c2.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> GridBuilderResult where C0: View, C1: View, C2: View, C3: View {
    var views: [GridElement] = []
    views.append(contentsOf: c0.extractContentViews())
    views.append(contentsOf: c1.extractContentViews())
    views.append(contentsOf: c2.extractContentViews())
    views.append(contentsOf: c3.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> GridBuilderResult where C0: View, C1: View, C2: View, C3: View, C4: View {
    var views: [GridElement] = []
    views.append(contentsOf: c0.extractContentViews())
    views.append(contentsOf: c1.extractContentViews())
    views.append(contentsOf: c2.extractContentViews())
    views.append(contentsOf: c3.extractContentViews())
    views.append(contentsOf: c4.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> GridBuilderResult where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View {
    var views: [GridElement] = []
    views.append(contentsOf: c0.extractContentViews())
    views.append(contentsOf: c1.extractContentViews())
    views.append(contentsOf: c2.extractContentViews())
    views.append(contentsOf: c3.extractContentViews())
    views.append(contentsOf: c4.extractContentViews())
    views.append(contentsOf: c5.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> GridBuilderResult where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View {
    var views: [GridElement] = []
    views.append(contentsOf: c0.extractContentViews())
    views.append(contentsOf: c1.extractContentViews())
    views.append(contentsOf: c2.extractContentViews())
    views.append(contentsOf: c3.extractContentViews())
    views.append(contentsOf: c4.extractContentViews())
    views.append(contentsOf: c5.extractContentViews())
    views.append(contentsOf: c6.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> GridBuilderResult where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View {
    var views: [GridElement] = []
    views.append(contentsOf: c0.extractContentViews())
    views.append(contentsOf: c1.extractContentViews())
    views.append(contentsOf: c2.extractContentViews())
    views.append(contentsOf: c3.extractContentViews())
    views.append(contentsOf: c4.extractContentViews())
    views.append(contentsOf: c5.extractContentViews())
    views.append(contentsOf: c6.extractContentViews())
    views.append(contentsOf: c7.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> GridBuilderResult where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View {
    var views: [GridElement] = []
    views.append(contentsOf: c0.extractContentViews())
    views.append(contentsOf: c1.extractContentViews())
    views.append(contentsOf: c2.extractContentViews())
    views.append(contentsOf: c3.extractContentViews())
    views.append(contentsOf: c4.extractContentViews())
    views.append(contentsOf: c5.extractContentViews())
    views.append(contentsOf: c6.extractContentViews())
    views.append(contentsOf: c7.extractContentViews())
    views.append(contentsOf: c8.extractContentViews())
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> GridBuilderResult where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View {
    var views: [GridElement] = []
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
    return GridBuilderResult(contentViews: views)
  }
  
  public static func buildEither(first: GridBuilderResult) -> GridBuilderResult { first }
  
  public static func buildEither(second: GridBuilderResult) -> GridBuilderResult { second }
  
  public static func buildIf(_ content: GridBuilderResult?) -> GridBuilderResult {
    content ?? GridBuilderResult(contentViews: [])
  }

  public static func buildOptional(_ component: GridBuilderResult?) -> GridBuilderResult {
    component ?? GridBuilderResult(contentViews: [])
  }
}
