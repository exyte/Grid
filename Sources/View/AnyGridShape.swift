//
//  AnyGridShape.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 10.06.2020.
//

import SwiftUI

struct AnyGridShape: Shape {
    private let pathGetter: (CGRect) -> Path
    
    init<T: Shape>(_ view: T) {
        self.pathGetter = { rect in
            return view.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        self.pathGetter(rect)
    }
}
