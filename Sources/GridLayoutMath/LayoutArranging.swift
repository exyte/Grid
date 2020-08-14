//
//  LayoutArranging.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import Foundation
import CoreGraphics

protocol LayoutArranging {
    func arrange(task: ArrangingTask) -> LayoutArrangement
}

struct ArrangementInfo: Equatable, Hashable {
    var gridItem: GridItem
    var start: GridStart
    var span: GridSpan
}

struct ArrangingTask: Equatable, Hashable {
    var itemsInfo: [ArrangementInfo]
    var tracks: [GridTrack]
    var flow: GridFlow
    var packing: GridPacking
}

extension LayoutArranging {

    func arrange(task: ArrangingTask) -> LayoutArrangement {
        let fixedTracksCount = task.tracks.count
        guard fixedTracksCount > 0 else { return .zero }
        let flow = task.flow
        let packing = task.packing
        var arrangedItems: [ArrangedItem] = []
        var occupiedIndices: [GridIndex] = []
        var growingTracksCount = 0

        var items: [ArrangementInfo] =
            task.itemsInfo.compactMap { itemInfo in
                var correctedSpan = itemInfo.span
                correctedSpan[keyPath: flow.spanIndex(.fixed)] = min(fixedTracksCount, correctedSpan[keyPath: flow.spanIndex(.fixed)])
                
                var correctedStart = itemInfo.start
                if let fixedStart = itemInfo.start[keyPath: flow.startIndex(.fixed)],
                    fixedStart > fixedTracksCount - 1 {
                    print("Warning: grid item start \(correctedStart) exceeds fixed tracks count: \(fixedTracksCount)")
                    correctedStart[keyPath: flow.startIndex(.fixed)] = nil
                }
                return .init(gridItem: itemInfo.gridItem, start: correctedStart, span: correctedSpan)
        }
        
        arrangedItems += self.arrangeFullyFrozenItems(&items,
                                                      flow: flow,
                                                      occupiedIndices: &occupiedIndices,
                                                      growingTracksCount: &growingTracksCount)
        arrangedItems += self.arrangeSemiFrozenItems(&items,
                                                     flow: flow,
                                                     fixedTracksCount: fixedTracksCount,
                                                     occupiedIndices: &occupiedIndices,
                                                     growingTracksCount: &growingTracksCount)
        arrangedItems += self.arrangeNonFrozenItem(items,
                                                   flow: flow,
                                                   fixedTracksCount: fixedTracksCount,
                                                   packing: packing,
                                                   occupiedIndices: &occupiedIndices,
                                                   growingTracksCount: &growingTracksCount)
        
        var arrangement = LayoutArrangement(columnsCount: 0, rowsCount: 0, items: arrangedItems)
        arrangement[keyPath: flow.arrangementCount(.fixed)] = fixedTracksCount
        arrangement[keyPath: flow.arrangementCount(.growing)] = growingTracksCount
        return arrangement
    }
    
    private func arrangeFullyFrozenItems(_ items: inout [ArrangementInfo], flow: GridFlow, occupiedIndices: inout [GridIndex],
                                         growingTracksCount: inout Int) -> [ArrangedItem] {
        var result: [ArrangedItem] = []
        let staticItems: [(item: GridItem, span: GridSpan, start: GridIndex)] =
            items.compactMap {
                guard
                    let columnStart = $0.start.column,
                    let rowStart = $0.start.row
                    else {
                        return nil
                }
                return ($0.gridItem, $0.span, GridIndex(column: columnStart, row: rowStart))
        }
        
        // Arrange fully static items
        staticItems.forEach { staticItem in
            let itemIndex = items.firstIndex(where: { $0.gridItem == staticItem.item })!
            guard
                !occupiedIndices.contains(staticItem.start, span: staticItem.span) else {
                    print("Warning: grid item position is occupied: \(staticItem.start), \(staticItem.span)")
                    
                    //Place that item automatically
                    let prevItem = items[itemIndex]
                items[itemIndex...itemIndex] = [.init(gridItem: prevItem.gridItem, start: GridStart.default, span: prevItem.span)]
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
        return result
    }
    
    private func arrangeSemiFrozenItems(_ items: inout [ArrangementInfo], flow: GridFlow, fixedTracksCount: Int,
                                        occupiedIndices: inout [GridIndex], growingTracksCount: inout Int) -> [ArrangedItem] {
        var result: [ArrangedItem] = []
        // Arrange static items with frozen start in fixed flow dimension
        for dimension in GridFlowDimension.allCases {
            let semiStaticFixedItems: [(item: GridItem, span: GridSpan, start: GridStart)] = items.compactMap {
                guard let frozenIndex = $0.start[keyPath: flow.startIndex(dimension)] else {
                    return nil
                }
                var correctedSpan = $0.span
                if dimension == .fixed {
                    correctedSpan[keyPath: flow.spanIndex(.fixed)] =
                        min(fixedTracksCount - frozenIndex, correctedSpan[keyPath: flow.spanIndex(.fixed)])
                }
                return ($0.gridItem, correctedSpan, $0.start)
            }
            
            semiStaticFixedItems.forEach { semiStaticItem in
                let itemIndex = items.firstIndex(where: { $0.gridItem == semiStaticItem.item })!
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
                        items[itemIndex...itemIndex] = [.init(gridItem: prevItem.gridItem, start: GridStart.default, span: prevItem.span)]
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
        return result
    }
    
    private func arrangeNonFrozenItem(_ items: [ArrangementInfo], flow: GridFlow, fixedTracksCount: Int, packing: GridPacking,
                                      occupiedIndices: inout [GridIndex], growingTracksCount: inout Int) -> [ArrangedItem] {
        // Arrange dynamic items
        var result: [ArrangedItem] = []
        var lastIndex: GridIndex = .zero
        for spanPreference in items {
            var currentIndex: GridIndex
            
            switch packing {
            case .sparse:
                currentIndex = lastIndex
            case .dense:
                currentIndex = .zero
            }
            
            while occupiedIndices.contains(currentIndex, span: spanPreference.span) {
                currentIndex = currentIndex.nextIndex(fixedTracksCount: fixedTracksCount,
                                                      flow: flow,
                                                      span: spanPreference.span)!
            }
            
            occupiedIndices.appendPointsFrom(index: currentIndex, span: spanPreference.span)
            let arrangedItem = ArrangedItem(item: spanPreference.gridItem,
                                            startIndex: currentIndex,
                                            span: spanPreference.span)
            
            growingTracksCount = max(growingTracksCount, arrangedItem.endIndex[keyPath: flow.index(.growing)] + 1)
            result.append(arrangedItem)
            lastIndex = currentIndex
        }
        return result
    }
}

fileprivate extension GridIndex {
    func nextIndex(fixedTracksCount: Int, flow: GridFlow, span: GridSpan, frozenDimension: GridFlowDimension? = nil) -> GridIndex? {
        var fixedIndex = self[keyPath: flow.index(.fixed)]
        var growingIndex = self[keyPath: flow.index(.growing)]
        let fixedSpan = span[keyPath: flow.spanIndex(.fixed)]

        func outerIncrementer() {
            switch frozenDimension {
            case .fixed:
                ()
            case .growing:
                fixedIndex += 1
            case .none:
                fixedIndex += 1
            }
        }
        
        func nextTrackTrigger() -> Bool? {
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
        
        func innerIncrementer() {
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
