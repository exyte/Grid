//
//  GridItemBuilder.swift
//  GridLayout
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

@_functionBuilder
struct GridItemsBuilder {
    
    static func buildBlock(_ item: GridArrangeable) -> GridArrangeable {
        return item
    }
    
    static func buildBlock(_ items: GridArrangeable...) -> [GridArrangeable] {
        return items
    }
    
    static func buildIf(_ item: GridArrangeable?) -> GridArrangeable? {
        item ?? EmptyGridItem()
    }
    
    static func buildEither(first: GridArrangeable) -> GridArrangeable {
        return first
    }

    static func buildEither(second: GridArrangeable) -> GridArrangeable {
        return second
    }
}
