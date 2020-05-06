//
//  GridFlow.swift
//  GridLayout
//
//  Created by Denis Obukhov on 24.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import CoreGraphics

public enum GridFlow {
    case columns
    case rows
}

extension GridFlow {
    var fixedIndex: WritableKeyPath<GridIndex, Int> {
        (self == .columns ? \GridIndex.column : \GridIndex.row)
    }
    
    var growingIndex: WritableKeyPath<GridIndex, Int> {
         (self == .rows ? \GridIndex.column : \GridIndex.row)
    }
    
    var fixedSpanIndex: WritableKeyPath<GridSpan, Int> {
        (self == .columns ? \GridSpan.column : \GridSpan.row)
    }
    
    var growingSpanIndex: WritableKeyPath<GridSpan, Int> {
         (self == .rows ? \GridSpan.column : \GridSpan.row)
    }
    
    var fixedSize: WritableKeyPath<CGSize, CGFloat> {
        (self == .columns ? \CGSize.width : \CGSize.height)
    }
    
    var growingSize: WritableKeyPath<CGSize, CGFloat> {
        (self == .rows ? \CGSize.width : \CGSize.height)
    }

    var arrangedItemGrowingCount: KeyPath<ArrangedItem, Int> {
        (self == .columns ? \ArrangedItem.rowsCount : \ArrangedItem.columnsCount)
    }

    var growingArrangementCount: WritableKeyPath<LayoutArrangement, Int> {
        (self == .columns ? \LayoutArrangement.rowsCount : \LayoutArrangement.columnsCount)
    }
    
    var fixedArrangementCount: WritableKeyPath<LayoutArrangement, Int> {
        (self == .rows ? \LayoutArrangement.rowsCount : \LayoutArrangement.columnsCount)
    }
    
    var fixedCGPointIndex: WritableKeyPath<CGPoint, CGFloat> {
        (self == .columns ? \CGPoint.x : \CGPoint.y)
    }
    
    var growingCGPointIndex: WritableKeyPath<CGPoint, CGFloat> {
         (self == .rows ? \CGPoint.x : \CGPoint.y)
    }
}
