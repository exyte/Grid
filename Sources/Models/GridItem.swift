//
//  GridItem.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

/// Fundamental identifiable element in a grid view
public struct GridItem: Identifiable {
    public var id: AnyHashable {
        if let newID = idPair.newID {
            return newID
        }
        return idPair.originID! }
    public var idPair: IDPair
    public let view: AnyView
    let debugID = UUID()
    
    public init<T: View>(_ view: T, id: AnyHashable) {
        self.view = AnyView(view)
        self.idPair = IDPair(originID: id, newID: nil)
    }

    public init<T: View>(_ view: T, idPair: IDPair) {
        self.view = AnyView(view)
        self.idPair = idPair
    }
}

extension GridItem: Equatable {
    public static func == (lhs: GridItem,
                           rhs: GridItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GridItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
