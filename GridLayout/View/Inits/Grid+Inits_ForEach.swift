//
//  Grid+Inits_ForEach.swift
//  GridLayout
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

//Single ForEach init
extension Grid {
    public init<T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(ForEach<Range<Int>, Int, T>)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            content().value.data.map { GridItem(AnyView(content().value.content($0)), id: AnyHashable(($0 + 10))) }
    }
}
