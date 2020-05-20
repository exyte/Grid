//
//  GridFlow.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 24.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import CoreGraphics

public enum GridFlow {
    case rows
    case columns
}

enum GridFlowDimension: CaseIterable {
    case fixed
    case growing
}

extension GridFlow {
    
    func index(_ dimension: GridFlowDimension) -> WritableKeyPath<GridIndex, Int> {
        switch dimension {
        case .fixed:
            return (self == .rows ? \GridIndex.column : \GridIndex.row)
        case .growing:
            return (self == .columns ? \GridIndex.column : \GridIndex.row)
        }
    }
    
    func spanIndex(_ dimension: GridFlowDimension) -> WritableKeyPath<GridSpan, Int> {
        switch dimension {
        case .fixed:
            return (self == .rows ? \GridSpan.column : \GridSpan.row)
        case .growing:
            return (self == .columns ? \GridSpan.column : \GridSpan.row)
        }
    }

    func size(_ dimension: GridFlowDimension) -> WritableKeyPath<CGSize, CGFloat> {
        switch dimension {
        case .fixed:
            return (self == .rows ? \CGSize.width : \CGSize.height)
        case .growing:
            return (self == .columns ? \CGSize.width : \CGSize.height)
        }
    }
    
    func arrangedItemCount(_ dimension: GridFlowDimension) -> KeyPath<ArrangedItem, Int> {
        switch dimension {
        case .fixed:
            return (self == .columns ? \ArrangedItem.rowsCount : \ArrangedItem.columnsCount)
        case .growing:
            return (self == .rows ? \ArrangedItem.rowsCount : \ArrangedItem.columnsCount)
        }
    }
    
    func arrangementCount(_ dimension: GridFlowDimension) -> WritableKeyPath<LayoutArrangement, Int> {
        switch dimension {
        case .fixed:
            return (self == .columns ? \LayoutArrangement.rowsCount : \LayoutArrangement.columnsCount)
        case .growing:
            return (self == .rows ? \LayoutArrangement.rowsCount : \LayoutArrangement.columnsCount)
        }
    }
    
    func cgPointIndex(_ dimension: GridFlowDimension) -> WritableKeyPath<CGPoint, CGFloat> {
        switch dimension {
        case .fixed:
            return (self == .rows ? \CGPoint.x : \CGPoint.y)
        case .growing:
            return (self == .columns ? \CGPoint.x : \CGPoint.y)
        }
    }
    
    func startIndex(_ dimension: GridFlowDimension) -> WritableKeyPath<GridStart, Int?> {
        switch dimension {
        case .fixed:
            return (self == .rows ? \GridStart.column : \GridStart.row)
        case .growing:
            return (self == .columns ? \GridStart.column : \GridStart.row)
        }
    }
}
