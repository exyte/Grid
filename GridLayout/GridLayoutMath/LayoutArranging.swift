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
        
        var lastIndex: GridIndex = .zero
        var growingTracksCount = 0

        var items: [(item: GridItem, span: GridSpan, start: GridStart?)] =
            spanPreferences.compactMap { spanPreference in
                guard let gridItem = spanPreference.item else { return nil }
                var correctedSpan = spanPreference.span
                correctedSpan[keyPath: flow.spanIndex(.fixed)] = min(fixedTracksCount, correctedSpan[keyPath: flow.spanIndex(.fixed)])
                let start = startPreferences.first(where: { $0.item == spanPreference.item })?.start
                return (gridItem, correctedSpan, start)
        }
        
        let staticItems: [(item: GridItem, span: GridSpan, start: GridIndex)] =
            items.compactMap {
                guard
                    let columnStart = $0.start?.column,
                    let rowStart = $0.start?.row
                else {
                    return nil
                }
                return ($0.item, $0.span, GridIndex(column: columnStart, row: rowStart))
            }
        
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
        
        for spanPreference in items {
            var currentIndex: GridIndex
            
            switch packing {
            case .sparse:
                currentIndex = lastIndex
            case .dense:
                currentIndex = .zero // TODO: Improve dense algorithm
            }
            
            while occupiedIndices.contains(currentIndex, span: spanPreference.span)
                || currentIndex[keyPath: flow.index(.fixed)] + spanPreference.span[keyPath: flow.spanIndex(.fixed)] > fixedTracksCount {
                    currentIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
            }

            occupiedIndices.appendPointsFrom(index: currentIndex, span: spanPreference.span)
            let arrangedItem = ArrangedItem(item: spanPreference.item,
                                            startIndex: currentIndex,
                                            span: spanPreference.span)

            growingTracksCount = max(growingTracksCount, arrangedItem.endIndex[keyPath: flow.index(.growing)] + 1)
            result.append(arrangedItem)
            lastIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
        }
        var arrangement = LayoutArrangement(columnsCount: 0, rowsCount: 0, items: result)
        arrangement[keyPath: flow.arrangementCount(.fixed)] = fixedTracksCount
        arrangement[keyPath: flow.arrangementCount(.growing)] = growingTracksCount
        return arrangement
    }
}

fileprivate extension GridIndex {
    func nextIndex(tracksCount: Int, flow: GridFlow) -> GridIndex {
        var fixedSize = self[keyPath: flow.index(.fixed)]
        var growingSize = self[keyPath: flow.index(.growing)]
        
        fixedSize += 1
        if fixedSize >= tracksCount {
            fixedSize = 0
            growingSize += 1
        }
        
        var nextIndex = GridIndex.zero
        nextIndex[keyPath: flow.index(.fixed)] = fixedSize
        nextIndex[keyPath: flow.index(.growing)] = growingSize
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
