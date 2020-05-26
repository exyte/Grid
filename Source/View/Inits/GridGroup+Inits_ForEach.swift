//
//  GridGroup+Inits_ForEach.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//

import SwiftUI

extension GridGroup {
    public init<Content: View>(@ViewBuilder content: () -> ForEach<Range<Int>, Int, Content>) {
        self.contentViews =
            content().data.flatMap { content().content($0).extractContentViews() }
    }
    
    public init<Data, Content: View>(@ViewBuilder content: () -> ForEach<Data, Data.Element.ID, Content>) where Data: RandomAccessCollection, Data.Element: Identifiable {
        self.contentViews =
            content().data.flatMap { content().content($0).extractContentViews() }
    }
    
    public init<Data: RandomAccessCollection, ID, Content: View>(@ViewBuilder content: () -> ForEach<Data, ID, Content>) {
        self.contentViews =
            content().data.flatMap { content().content($0).extractContentViews() }
    }
}
