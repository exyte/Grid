//
//  Grid+Inits_ForEach.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

//swiftlint:disable line_length
import SwiftUI

//Single ForEach init
extension Grid {
    public init(tracks: [GridTrack] = 1, contentMode: GridContentMode? = nil, flow: GridFlow? = nil, packing: GridPacking? = nil, spacing: GridSpacing = Constants.defaultSpacing, cache: GridCacheMode? = nil, @ViewBuilder content: () -> ForEach<Range<Int>, Int, Content>) {
        self.trackSizes = tracks
        self.spacing = spacing
        self.internalContentMode = contentMode
        self.internalFlow = flow
        self.internalPacking = packing
        self.internalCacheMode = cache
        self.items = content().data
            .flatMap { content().content($0).asGridItems(hash: $0) }
    }
    
    public init<Data>(tracks: [GridTrack] = 1, contentMode: GridContentMode? = nil, flow: GridFlow? = nil, packing: GridPacking? = nil, spacing: GridSpacing = Constants.defaultSpacing, cache: GridCacheMode? = nil, @ViewBuilder content: () -> ForEach<Data, Data.Element.ID, Content>) where Data: RandomAccessCollection, Data.Element: Identifiable {
        self.trackSizes = tracks
        self.spacing = spacing
        self.internalContentMode = contentMode
        self.internalFlow = flow
        self.internalPacking = packing
        self.internalCacheMode = cache
        self.items = content().data
            .flatMap { content().content($0).asGridItems(hash: $0.id) }
    }
    
    public init<Data: RandomAccessCollection, ID>(tracks: [GridTrack] = 1, contentMode: GridContentMode? = nil, flow: GridFlow? = nil, packing: GridPacking? = nil, spacing: GridSpacing = Constants.defaultSpacing, cache: GridCacheMode? = nil, @ViewBuilder content: () -> ForEach<Data, ID, Content>) {
        self.trackSizes = tracks
        self.spacing = spacing
        self.internalContentMode = contentMode
        self.internalFlow = flow
        self.internalPacking = packing
        self.internalCacheMode = cache
        self.items = content().data
            .enumerated()
            .flatMap { content().content($0.element).asGridItems(hash: [$0.offset]) }
    }
}
