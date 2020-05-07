//
//  ForEach+GridViewsContaining.swift
//  GridLayout
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

extension ForEach: GridViewsContaining where Data == Range<Int>, ID == Int, Content: View {
    var views: [AnyView] {
        self.data.map { AnyView(self.content($0)) }
    }
}
