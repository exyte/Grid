//
//  ForEach+GridViewsContaining.swift
//  GridLayout
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

extension ForEach: GridForEachRangeInt where Data == Range<Int>, ID == Int, Content: View {
    var contentViews: [AnyView] {
        self.data.map { AnyView(self.content($0)) }
    }
}

extension ForEach: GridForEachIdentifiable where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
    var contentViews: [AnyView] {
        self.data.map { AnyView(self.content($0)) }
    }
}

extension ForEach: GridForEachID where Content: View {
    var contentViews: [AnyView] {
        self.data.map { AnyView(self.content($0)) }
    }
}
