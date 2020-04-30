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
    var fixedIndex: WritableKeyPath<GridIndexing, Int> {
        (self == .columns ? \GridIndexing.column : \GridIndexing.row)
    }
    
    var growingIndex: WritableKeyPath<GridIndexing, Int> {
         (self == .rows ? \GridIndexing.column : \GridIndexing.row)
    }
    
    var fixedPointIndex: WritableKeyPath<GridPoint, Int> {
        (self == .columns ? \GridPoint.column : \GridPoint.row)
    }
    
    var growingPointIndex: WritableKeyPath<GridPoint, Int> {
         (self == .rows ? \GridPoint.column : \GridPoint.row)
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
