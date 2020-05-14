//
//  LayoutArranging.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation
import CoreGraphics

protocol LayoutArranging {
    /// Arranges grid items into layout arrangement that specifies relations between abstract position in grid view and specific item
    /// - Parameters:
    ///   - spanPreferences: Grid items associated with rows and columns spans
    ///   - startPreferences: Grid items associated with start positions
    ///   - fixedTracksCount: Total count of fixed tracks in grid view
    ///   - flow: Distribution order of grid items
    ///   - packing: Defines placement algorithm
    func arrange(spanPreferences: [SpanPreference], startPreferences: [StartPreference], fixedTracksCount: Int, flow: GridFlow, packing: GridPacking) -> LayoutArrangement
}

extension LayoutArranging {
    func arrange(spanPreferences: [SpanPreference], startPreferences: [StartPreference], fixedTracksCount: Int, flow: GridFlow, packing: GridPacking) -> LayoutArrangement {
        guard fixedTracksCount > 0 else { return .zero }
            
        var result: [ArrangedItem] = []
        var occupiedIndices: [GridIndex] = []
 
        var growingTracksCount = 0

        var items: [(item: GridItem, span: GridSpan, start: GridStart)] =
            spanPreferences.compactMap { spanPreference in
                guard let gridItem = spanPreference.item,
                    let gridStart = startPreferences.first(where: { $0.item == spanPreference.item })?.start
                else {
                    return nil
                }
                var correctedSpan = spanPreference.span
                correctedSpan[keyPath: flow.spanIndex(.fixed)] = min(fixedTracksCount, correctedSpan[keyPath: flow.spanIndex(.fixed)])
                
                var correctedStart = gridStart
                if let fixedStart = gridStart[keyPath: flow.startIndex(.fixed)],
                    fixedStart > fixedTracksCount {
                    print("Warning: grid item start \(gridStart) exceeds fixed tracks count: \(fixedTracksCount)")
                    correctedStart[keyPath: flow.startIndex(.fixed)] = nil
                }
                return (gridItem, correctedSpan, correctedStart)
        }
        
        let staticItems: [(item: GridItem, span: GridSpan, start: GridIndex)] =
            items.compactMap {
                guard
                    let columnStart = $0.start.column,
                    let rowStart = $0.start.row
                else {
                    return nil
                }
                return ($0.item, $0.span, GridIndex(column: columnStart, row: rowStart))
            }
        
        // Arrange fully static items
        staticItems.forEach { staticItem in
            let itemIndex = items.firstIndex(where: { $0.item == staticItem.item })!
            guard
                !occupiedIndices.contains(staticItem.start, span: staticItem.span) else {
                print("Warning: grid item position is occupied: \(staticItem.start), \(staticItem.span)")
                
                //Place that item automatically
                let prevItem = items[itemIndex]
                items[itemIndex...itemIndex] = [(prevItem.item, prevItem.span, GridStart.default)]
                return
            }
            occupiedIndices.appendPointsFrom(index: staticItem.start, span: staticItem.span)
            let arrangedItem = ArrangedItem(item: staticItem.item,
                                            startIndex: staticItem.start,
                                            span: staticItem.span)
            growingTracksCount = max(growingTracksCount, arrangedItem.endIndex[keyPath: flow.index(.growing)] + 1)
            result.append(arrangedItem)
            items.remove(at: itemIndex)
        }
        
        // Arrange static items with frozen start in fixed flow dimension
        for dimension in GridFlowDimension.allCases {
            let semiStaticFixed: [(item: GridItem, span: GridSpan, start: GridStart)] = items.compactMap {
                guard let frozenIndex = $0.start[keyPath: flow.startIndex(dimension)] else {
                    return nil
                }
                var correctedSpan = $0.span
                if dimension == .fixed {
                    correctedSpan[keyPath: flow.spanIndex(.fixed)] =
                        min(fixedTracksCount - frozenIndex, correctedSpan[keyPath: flow.spanIndex(.fixed)])
                }
                return ($0.item, correctedSpan, $0.start)
            }

            semiStaticFixed.forEach { semiStaticItem in
                let itemIndex = items.firstIndex(where: { $0.item == semiStaticItem.item })!
                let frozenIndex = semiStaticItem.start[keyPath: flow.startIndex(dimension)]!
                
                var currentIndex: GridIndex = .zero
                currentIndex[keyPath: flow.index(dimension)] = frozenIndex
                
                while occupiedIndices.contains(currentIndex, span: semiStaticItem.span) {
                    guard let nextIndex = currentIndex.nextIndex(fixedTracksCount: fixedTracksCount,
                                                                 flow: flow,
                                                                 span: semiStaticItem.span,
                                                                 frozenDimension: dimension)
                    else {
                        print("Warning: unable to place semi-fixed grid item with start: \(semiStaticItem.start), span: \(semiStaticItem.span)")
                        //Place that item automatically
                        
                        let prevItem = items[itemIndex]
                        items[itemIndex...itemIndex] = [(prevItem.item, prevItem.span, GridStart.default)]
                        return
                    }
                    currentIndex = nextIndex
                }
                
                occupiedIndices.appendPointsFrom(index: currentIndex, span: semiStaticItem.span)
                let arrangedItem = ArrangedItem(item: semiStaticItem.item,
                                                startIndex: currentIndex,
                                                span: semiStaticItem.span)
                growingTracksCount = max(growingTracksCount, arrangedItem.endIndex[keyPath: flow.index(.growing)] + 1)
                result.append(arrangedItem)
                items.remove(at: itemIndex)
            }
        }

        // Arrange dynamic items
        
        var lastIndex: GridIndex = .zero
        for spanPreference in items {
            var currentIndex: GridIndex
            
            switch packing {
            case .sparse:
                currentIndex = lastIndex
            case .dense:
                currentIndex = .zero // TODO: Improve dense algorithm
            }
            
            while occupiedIndices.contains(currentIndex, span: spanPreference.span) {
                currentIndex = currentIndex.nextIndex(fixedTracksCount: fixedTracksCount,
                                                      flow: flow,
                                                      span: spanPreference.span)!
            }

            occupiedIndices.appendPointsFrom(index: currentIndex, span: spanPreference.span)
            let arrangedItem = ArrangedItem(item: spanPreference.item,
                                            startIndex: currentIndex,
                                            span: spanPreference.span)

            growingTracksCount = max(growingTracksCount, arrangedItem.endIndex[keyPath: flow.index(.growing)] + 1)
            result.append(arrangedItem)
            lastIndex = currentIndex
        }
        var arrangement = LayoutArrangement(columnsCount: 0, rowsCount: 0, items: result)
        arrangement[keyPath: flow.arrangementCount(.fixed)] = fixedTracksCount
        arrangement[keyPath: flow.arrangementCount(.growing)] = growingTracksCount
        return arrangement
    }
}

fileprivate extension GridIndex {
    func nextIndex(fixedTracksCount: Int, flow: GridFlow, span: GridSpan, frozenDimension: GridFlowDimension? = nil) -> GridIndex? {
        var fixedIndex = self[keyPath: flow.index(.fixed)]
        var growingIndex = self[keyPath: flow.index(.growing)]
        let fixedSpan = span[keyPath: flow.spanIndex(.fixed)]

        let outerIncrementer = {
            switch frozenDimension {
            case .fixed:
                ()
            case .growing:
                fixedIndex += 1
            case .none:
                fixedIndex += 1
            }
        }
        
        let nextTrackTrigger: () -> Bool? = {
            switch frozenDimension {
            case .fixed:
                return true
            case .growing:
                guard fixedIndex + fixedSpan <= fixedTracksCount else {
                    return nil
                }
                return false
            case .none:
                return fixedIndex + fixedSpan > fixedTracksCount
            }
        }
        
        let innerIncrementer = {
            switch frozenDimension {
            case .fixed:
                growingIndex += 1
            case .growing:
                ()
            case .none:
                fixedIndex = 0
                growingIndex += 1
            }
        }
        
        outerIncrementer()
        guard let result = nextTrackTrigger() else {
            return nil
        }
        if result {
            innerIncrementer()
        }
        
        var nextIndex = GridIndex.zero
        nextIndex[keyPath: flow.index(.fixed)] = fixedIndex
        nextIndex[keyPath: flow.index(.growing)] = growingIndex
        return nextIndex
    }
}

fileprivate extension Array where Element == GridIndex {
    func contains(_ startIndex: GridIndex, span: GridSpan) -> Bool {
        for row in startIndex.row..<startIndex.row + span.row {
            for column in startIndex.column..<startIndex.column + span.column {
                if self.contains(GridIndex(column: column, row: row)) {
                    return true
                }
            }
        }
        return false
    }

    mutating func appendPointsFrom(index: GridIndex, span: GridSpan) {
        for row in index.row..<index.row + span.row {
            for column in index.column..<index.column + span.column {
                self.append(GridIndex(column: column, row: row))
            }
        }
    }
}
