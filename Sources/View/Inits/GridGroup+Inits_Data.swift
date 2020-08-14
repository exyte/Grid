//
//  GridGroup+Inits_Data.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 26.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension GridGroup {
    public init<Data, ID, Content: View>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder item: @escaping (Data.Element) -> Content) where Data: RandomAccessCollection, ID: Hashable {
        self.contentViews = data.map { (AnyHashable([AnyHashable($0[keyPath: id]), AnyHashable(id)]), AnyView(item($0))) }
    }
    
    public init<Content: View>(_ data: Range<Int>, @ViewBuilder item: @escaping (Int) -> Content) {
        self.contentViews = data.map { (nil, AnyView(item($0))) }
    }
    
    public init<Data, Content: View>(_ data: Data, @ViewBuilder item: @escaping (Data.Element) -> Content) where Data: RandomAccessCollection, Data.Element: Identifiable {
        self.contentViews = data.map { (AnyHashable($0.id), AnyView(item($0))) }
    }

    public init<Data: Identifiable, Content: View>(_ data: Data, @ViewBuilder item: @escaping (Data) -> Content) {
        self.init([data], item: item)
    }

    public init<Data: Hashable, Content: View>(_ data: Data, @ViewBuilder item: @escaping (Data) -> Content) {
        self.init([data], id: \.self, item: item)
    }
}
