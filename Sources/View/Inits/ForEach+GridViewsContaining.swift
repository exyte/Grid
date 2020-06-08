//
//  ForEach+GridViewsContaining.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension ForEach: GridForEachRangeInt where Data == Range<Int>, ID == Int, Content: View {
    var contentViews: [IdentifyingAnyView] {
        self.data.map { (AnyHashable($0), AnyView(self.content($0))) }
    }
}

extension ForEach: GridForEachIdentifiable where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
    var contentViews: [IdentifyingAnyView] {
        self.data.map { (AnyHashable($0.id), AnyView(self.content($0))) }
    }
}

extension ForEach: GridForEachID where Content: View {
    var contentViews: [IdentifyingAnyView] {
        self.data.map { (nil, AnyView(self.content($0))) }
    }
}

#if DEBUG

// To be available on preview canvas

extension ModifiedContent: GridForEachRangeInt where Content: GridForEachRangeInt, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
    var contentViews: [IdentifyingAnyView] {
        return self.content.contentViews
    }
}

extension ModifiedContent: GridForEachIdentifiable where Content: GridForEachIdentifiable, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
    var contentViews: [IdentifyingAnyView] {
        return self.content.contentViews
    }
}

extension ModifiedContent: GridForEachID where Content: GridForEachID, Modifier == _IdentifiedModifier<__DesignTimeSelectionIdentifier> {
    var contentViews: [IdentifyingAnyView] {
        return self.content.contentViews
    }
}

#endif
