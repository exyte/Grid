//
//  Grid+Inits_TupleView.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 18.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

// swiftlint:disable line_length

import SwiftUI

extension Grid {
    public init(tracks: [GridTrack] = 1, contentMode: GridContentMode? = nil, flow: GridFlow? = nil, packing: GridPacking? = nil, spacing: GridSpacing = Constants.defaultSpacing, itemsAlignment: Alignment? = nil, cache: GridCacheMode? = nil, @GridBuilder content: () -> ConstructionItem) {
        self.trackSizes = tracks
        self.spacing = spacing
        self.internalContentMode = contentMode
        self.internalFlow = flow
        self.internalPacking = packing
        self.internalCacheMode = cache
        self.internalItemsAlignment = itemsAlignment
        
        let content = content()
        var index = 0
        self.items = content.contentViews.asGridElements(index: &index)
    }
}
