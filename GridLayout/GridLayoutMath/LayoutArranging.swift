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
    ///   - spanPreferences: Grid items to arrange. They could specify row and columns spans
    ///   - fixedTracksCount: Total count of fixed tracks in grid view
    ///   - flow: Distribution order of grid items
    ///   - packing: Defines placement algorithm
    func arrange(spanPreferences: [SpanPreference], fixedTracksCount: Int, flow: GridFlow, packing: GridPacking) -> LayoutArrangement
    
    /// Recalculates positions based on layout arrangement and bounding size
    /// - Parameters:
    ///   - position: Items to reposition
    ///   - arrangement: Previously calculated arrangement
    ///   - boundingSize: Bounding size
    ///   - tracks: Sizes of tracks
    ///   - contentMode: Where the content will be scrolled or filled inside a grid
    ///   - flow: Distribution order of grid items
    ///   - spacing: Spacing between items
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [GridTrack], contentMode: GridContentMode, flow: GridFlow, spacing: CGFloat) -> PositionsPreference
}

private struct PositionedTrack {
    let track: GridTrack
    var baseSize: CGFloat
}

extension LayoutArranging {
    
    func arrange(spanPreferences: [SpanPreference], fixedTracksCount: Int, flow: GridFlow, packing: GridPacking) -> LayoutArrangement {
        guard fixedTracksCount > 0 else { return .zero }
            
        var result: [ArrangedItem] = []
        var occupiedIndices: [GridIndex] = []
        
        var lastIndex: GridIndex = .zero
        var growingTracksCount = 0

        for spanPreference in spanPreferences {
            guard let gridItem = spanPreference.item else { continue }
            
            var correctedSpan = spanPreference.span
            correctedSpan[keyPath: flow.fixedSpanIndex] = min(fixedTracksCount, correctedSpan[keyPath: flow.fixedSpanIndex])
            var currentIndex: GridIndex
            
            switch packing {
            case .sparse:
                currentIndex = lastIndex
            case .dense:
                currentIndex = .zero // TODO: Improve dense algorithm
            }
            
            while occupiedIndices.contains(currentIndex, rowSpan: correctedSpan.row, columnSpan: correctedSpan.column)
                || currentIndex[keyPath: flow.fixedIndex] + correctedSpan[keyPath: flow.fixedSpanIndex] > fixedTracksCount {
                    currentIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
            }

            for row in currentIndex.row..<currentIndex.row + correctedSpan.row {
                for column in currentIndex.column..<currentIndex.column + correctedSpan.column {
                    occupiedIndices.append(GridIndex(column: column, row: row))
                }
            }
            
            let startIndex = currentIndex
            var endIndex: GridIndex = .zero
            endIndex[keyPath: flow.fixedIndex] = startIndex[keyPath: flow.fixedIndex] + correctedSpan[keyPath: flow.fixedSpanIndex] - 1
            endIndex[keyPath: flow.growingIndex] = startIndex[keyPath: flow.growingIndex] + correctedSpan[keyPath: flow.growingSpanIndex] - 1

            let arrangedItem = ArrangedItem(gridItem: gridItem, startIndex: startIndex, endIndex: endIndex)
            growingTracksCount = max(growingTracksCount, arrangedItem.endIndex[keyPath: flow.growingIndex] + 1)
            result.append(arrangedItem)
            lastIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
        }
        var arrangement = LayoutArrangement(columnsCount: 0, rowsCount: 0, items: result)
        arrangement[keyPath: flow.fixedArrangementCount] = fixedTracksCount
        arrangement[keyPath: flow.growingArrangementCount] = growingTracksCount
        return arrangement
    }
    
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [GridTrack], contentMode: GridContentMode, flow: GridFlow, spacing: CGFloat) -> PositionsPreference {
        
        /// 1. Calculate growing track sizes as max of all the items within a track
        let growingTracksSizes: [CGFloat] = self.calculateGrowingSizes(position: position,
                                                                       arrangement: arrangement,
                                                                       contentMode: contentMode,
                                                                       flow: flow)
        /// 2. Calculate fixed track sizes
        let fixedTracksSizes = self.calculateFixedTrackSizes(position: position,
                                                            arrangement: arrangement,
                                                            boundingSize: boundingSize,
                                                            tracks: tracks,
                                                            flow: flow,
                                                            spacing: spacing)
        /// 4. Position items using calculated track sizes
        var newPositions: [PositionedItem] = []
        
        for positionedItem in position.items {
            guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
            let itemGrowingSize: CGFloat
            let growingPosition: CGFloat
            
            switch contentMode {
            case .fill:
                let growingSize = boundingSize[keyPath: flow.growingSize] / CGFloat(arrangement[keyPath: flow.growingArrangementCount])
                itemGrowingSize = growingSize * CGFloat(arrangedItem[keyPath: flow.arrangedItemGrowingCount])
                growingPosition = growingSize * CGFloat(arrangedItem.startIndex[keyPath: flow.growingIndex])
            case .scroll:
                itemGrowingSize = (arrangedItem.startIndex[keyPath: flow.growingIndex]...arrangedItem.endIndex[keyPath: flow.growingIndex]).reduce(0, { result, index in
                    return result + growingTracksSizes[index]
                })
                let centringCorrection = (itemGrowingSize - positionedItem.bounds.size[keyPath: flow.growingSize]) / 2
                growingPosition = (0..<arrangedItem.startIndex[keyPath: flow.growingIndex]).reduce(0, { result, index in
                    return result + growingTracksSizes[index]
                }) + centringCorrection
            }

            let fixedTrackStart = fixedTracksSizes[0..<arrangedItem.startIndex[keyPath: flow.fixedIndex]].reduce(0, +)
            let fixedTrackSize = fixedTracksSizes[arrangedItem.startIndex[keyPath: flow.fixedIndex]...arrangedItem.endIndex[keyPath: flow.fixedIndex]].reduce(0, +)
            
            var newBounds = CGRect.zero
            newBounds.size[keyPath: flow.growingSize] = itemGrowingSize.rounded()
            newBounds.size[keyPath: flow.fixedSize] = fixedTrackSize.rounded()
            newBounds.origin[keyPath: flow.growingCGPointIndex] = growingPosition.rounded()
            newBounds.origin[keyPath: flow.fixedCGPointIndex] = fixedTrackStart.rounded()

            newPositions.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
        }
        
        let totalGrowingSize = growingTracksSizes.reduce(0, +)
        let totalFixedSize = fixedTracksSizes.reduce(0, +)
        var totalSize = CGSize.zero
        totalSize[keyPath: flow.fixedSize] = totalFixedSize.rounded()
        totalSize[keyPath: flow.growingSize] = totalGrowingSize.rounded()
        return PositionsPreference(items: newPositions, size: totalSize)
    }
    
    private func calculateGrowingSizes(position: PositionsPreference, arrangement: LayoutArrangement,
                                       contentMode: GridContentMode, flow: GridFlow) -> [CGFloat] {
        var sizes: [CGFloat] = .init(repeating: 0, count: arrangement[keyPath: flow.growingArrangementCount])
        if case .scroll = contentMode {
            for positionedItem in position.items {
                guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
                
                let itemSelfSize = positionedItem.bounds.size[keyPath: flow.growingSize]
                let itemRangeStart = arrangedItem.startIndex[keyPath: flow.growingIndex]
                let itemRangeEnd = arrangedItem.endIndex[keyPath: flow.growingIndex]
                for index in itemRangeStart...itemRangeEnd {
                    let growingCount = arrangedItem[keyPath: flow.arrangedItemGrowingCount]
                    sizes[index] = max(sizes[index], itemSelfSize / CGFloat(growingCount))
                }
            }
        }
        return sizes
    }
    
    private func calculateFixedTrackSizes(position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [GridTrack], flow: GridFlow, spacing: CGFloat) -> [CGFloat] {
        /// 1. Initialize sizes
        var fixedTracksSizes: [PositionedTrack] =
            tracks.map { track in
                switch track {
                case .fr:
                    return PositionedTrack(track: track, baseSize: 0)
                case .const(let size):
                    return PositionedTrack(track: track, baseSize: CGFloat(size))
                case .fitContent:
                    return PositionedTrack(track: track, baseSize: 0)
                }
        }
        
        let totalSpacingLength = self.totalSpacingLength(arrangement: arrangement,
                                                         flow: flow,
                                                         spacing: spacing)
        let totalAvailableSpace = boundingSize[keyPath: flow.fixedSize]  - totalSpacingLength
        
        /// 2. Resolve Intrinsic Track Sizes
        
        /// 2.1. Size tracks to fit non-spanning items
        for (trackIndex, _) in fixedTracksSizes.enumerated().filter({ $0.element.track.isIntrinsic }) {
            let arrangedNoSpanItems = arrangement.items.filter { $0.startIndex[keyPath: flow.fixedIndex] == trackIndex }
            let positionedNoSpanItems = arrangedNoSpanItems.compactMap { position[$0] }
            let maxSize = positionedNoSpanItems
                .map(\.bounds.size)
                .map { $0[keyPath: flow.fixedSize] }
                .max()
            
            fixedTracksSizes[trackIndex].baseSize = maxSize ?? fixedTracksSizes[trackIndex].baseSize
        }
        
        /// 2.2. Increase sizes to accommodate spanning items
        let arrangedSpannedItems = arrangement.items
            .filter { $0.span[keyPath: flow.fixedSpanIndex] > 1}
        
        var spansMap: [Int: [ArrangedItem]] = [:]
        arrangedSpannedItems.forEach { arrangedItem in
            let items = spansMap[arrangedItem.span[keyPath: flow.fixedSpanIndex]] ?? []
            spansMap[arrangedItem.span[keyPath: flow.fixedSpanIndex]] = items + [arrangedItem]
        }
        
        for span in spansMap.keys.sorted(by: <) {
            var plannedIncreases = [CGFloat?](repeating: nil, count: fixedTracksSizes.count)
            for arrangedItem in spansMap[span] ?? [] {
                let start = arrangedItem.startIndex[keyPath: flow.fixedIndex]
                let end = arrangedItem.endIndex[keyPath: flow.fixedIndex]
                
                ///Consider the items that do not span a track with a flexible size
                if (tracks[start...end].contains { $0.isFlexible }) { continue }
                
                let trackSizes = fixedTracksSizes[start...end].map(\.baseSize).reduce(0, +)
                let itemSize = position[arrangedItem]?.bounds.size[keyPath: flow.fixedSize]
                let spaceToDistribute = max(0, (itemSize ?? 0) - trackSizes)
                (start...end).forEach {
                    guard let plannedIncrease = plannedIncreases[$0] else { return }
                    plannedIncreases[$0] = plannedIncrease + spaceToDistribute / CGFloat(span)
                }
            }
            
            let existingSizes = fixedTracksSizes.map(\.baseSize).reduce(0, +)
            let totalPlannedIncrease = plannedIncreases.compactMap({ $0 }).reduce(0, +)
            let freeSpace = max(0, totalAvailableSpace - existingSizes)
            let exceededIncrease = max(0, totalPlannedIncrease - freeSpace)
            
            /// 2.2.1 Subtract exceeded increase proportionally to the planned ones
            if let minValue = plannedIncreases.compactMap({ $0 }).min() {
                let normalizedIncreases = plannedIncreases.map { increase -> CGFloat? in
                    guard let plannedIncrease = increase else { return increase }
                    return plannedIncrease / minValue
                }
                let fractionValue = exceededIncrease / normalizedIncreases.compactMap({ $0 }).reduce(0, +)
                for (index, plannedIncrease) in plannedIncreases.enumerated() {
                    guard
                        let plannedIncrease = plannedIncrease,
                        let normalizedIncrease = normalizedIncreases[index]
                    else {
                        continue
                    }
                    plannedIncreases[index] = plannedIncrease - normalizedIncrease * fractionValue
                }
            }

            for (index, plannedIncrease) in plannedIncreases.enumerated() {
                guard let plannedIncrease = plannedIncrease else {
                    continue
                }
                fixedTracksSizes[index].baseSize += plannedIncrease
            }
        }
        
        /// 3. Expand Flexible Tracks
        let totalConstsSize = fixedTracksSizes.map(\.baseSize).reduce(0, +)
        let fractionsCount: CGFloat = fixedTracksSizes.reduce(0) { result, positionedTrack in
            if case .fr(let fraction) = positionedTrack.track {
                return result + fraction
            }
            return result
        }

        let freeSpace = max(0, totalAvailableSpace - totalConstsSize)
        let fractionValue = max(0, freeSpace / fractionsCount)
        
        for (trackIndex, positionedTrack) in fixedTracksSizes.enumerated() {
            if case .fr(let fraction) = positionedTrack.track {
                let baseSize = fixedTracksSizes[trackIndex].baseSize
                fixedTracksSizes[trackIndex].baseSize = max(fraction * fractionValue, baseSize)
            }
        }
        
        print("Used space: \(fixedTracksSizes.map(\.baseSize).reduce(0, +) + totalSpacingLength)")
        print("Available: \(boundingSize[keyPath: flow.fixedSize])")
        return fixedTracksSizes.map(\.baseSize)
    }
    
    private func totalSpacingLength(arrangement: LayoutArrangement, flow: GridFlow, spacing: CGFloat) -> CGFloat {
        let maxUniqueCount =
            Array(0..<arrangement[keyPath: flow.growingArrangementCount])
                .map { trackIndex in
                    arrangement.items
                        .filter {
                            let start = $0.startIndex[keyPath: flow.growingIndex]
                            let end = $0.endIndex[keyPath: flow.growingIndex]
                            return (start...end).contains(trackIndex)
                        }
                        .count
                }
                .max()
        let result = CGFloat(max(0, (maxUniqueCount ?? 0) - 1)) * spacing
        return result
    }
}

extension GridIndex {
    fileprivate func nextIndex(tracksCount: Int, flow: GridFlow) -> GridIndex {
        var fixedSize = self[keyPath: flow.fixedIndex]
        var growingSize = self[keyPath: flow.growingIndex]
        
        fixedSize += 1
        if fixedSize >= tracksCount {
            fixedSize = 0
            growingSize += 1
        }
        
        var nextIndex = GridIndex.zero
        nextIndex[keyPath: flow.fixedIndex] = fixedSize
        nextIndex[keyPath: flow.growingIndex] = growingSize
        return nextIndex
    }
}

extension Array where Element == GridIndex {
    fileprivate func contains(_ startIndex: GridIndex, rowSpan: Int, columnSpan: Int) -> Bool {
        for row in startIndex.row..<startIndex.row + rowSpan {
            for column in startIndex.column..<startIndex.column + columnSpan {
                if self.contains(GridIndex(column: column, row: row)) {
                    return true
                }
            }
        }
        
        return false
    }
}
