//
//  View+If.swift
//  Grid
//
//  Created by Denis Obukhov on 08.12.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
