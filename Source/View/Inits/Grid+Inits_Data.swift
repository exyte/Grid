//
//  Grid+Inits_Data.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

// swiftlint:disable line_length

import SwiftUI

extension Grid {
    public init<Data, ID>(_ data: Data, id: KeyPath<Data.Element, ID>, tracks: [GridTrack], spacing: GridSpacing = Constants.defaultSpacing, @ViewBuilder item: @escaping (Data.Element) -> Content) where Data: RandomAccessCollection, ID: Hashable {
        self.items = data.map { GridItem(AnyView(item($0)), id: AnyHashable($0[keyPath: id])) }
        self.trackSizes = tracks
        self.spacing = spacing
    }
    
    public init(_ data: Range<Int>, tracks: [GridTrack], spacing: GridSpacing = Constants.defaultSpacing, @ViewBuilder item: @escaping (Int) -> Content) {
        self.items = data.map { GridItem(AnyView(item($0)), id: AnyHashable($0)) }
        self.trackSizes = tracks
        self.spacing = spacing
    }
    
    public init<Data>(_ data: Data, tracks: [GridTrack], spacing: GridSpacing = Constants.defaultSpacing, @ViewBuilder item: @escaping (Data.Element) -> Content) where Data: RandomAccessCollection, Data.Element: Identifiable {
        self.items = data.map { GridItem(AnyView(item($0)), id: AnyHashable($0.id)) }
        self.trackSizes = tracks
        self.spacing = spacing
    }
}
