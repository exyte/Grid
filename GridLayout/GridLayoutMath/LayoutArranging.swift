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
            correctedSpan[keyPath: flow.spanIndex(.fixed)] = min(fixedTracksCount, correctedSpan[keyPath: flow.spanIndex(.fixed)])
            var currentIndex: GridIndex
            
            switch packing {
            case .sparse:
                currentIndex = lastIndex
            case .dense:
                currentIndex = .zero // TODO: Improve dense algorithm
            }
            
            while occupiedIndices.contains(currentIndex, rowSpan: correctedSpan.row, columnSpan: correctedSpan.column)
                || currentIndex[keyPath: flow.index(.fixed)] + correctedSpan[keyPath: flow.spanIndex(.fixed)] > fixedTracksCount {
                    currentIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
            }

            for row in currentIndex.row..<currentIndex.row + correctedSpan.row {
                for column in currentIndex.column..<currentIndex.column + correctedSpan.column {
                    occupiedIndices.append(GridIndex(column: column, row: row))
                }
            }
            
            let startIndex = currentIndex
            var endIndex: GridIndex = .zero
            endIndex[keyPath: flow.index(.fixed)] = startIndex[keyPath: flow.index(.fixed)] + correctedSpan[keyPath: flow.spanIndex(.fixed)] - 1
            endIndex[keyPath: flow.index(.growing)] = startIndex[keyPath: flow.index(.growing)] + correctedSpan[keyPath: flow.spanIndex(.growing)] - 1

            let arrangedItem = ArrangedItem(gridItem: gridItem, startIndex: startIndex, endIndex: endIndex)
            growingTracksCount = max(growingTracksCount, arrangedItem.endIndex[keyPath: flow.index(.growing)] + 1)
            result.append(arrangedItem)
            lastIndex = currentIndex.nextIndex(tracksCount: fixedTracksCount, flow: flow)
        }
        var arrangement = LayoutArrangement(columnsCount: 0, rowsCount: 0, items: result)
        arrangement[keyPath: flow.arrangementCount(.fixed)] = fixedTracksCount
        arrangement[keyPath: flow.arrangementCount(.growing)] = growingTracksCount
        return arrangement
    }
    
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [GridTrack], contentMode: GridContentMode, flow: GridFlow, spacing: CGFloat) -> PositionsPreference {
        
        /// 1. Calculate growing track sizes as max of all the items within a track
        let growingTracks: [GridTrack]
        let growingBoundingSize: CGFloat
        if contentMode == .scroll {
            growingTracks = [GridTrack](repeating: .fitContent, count: arrangement[keyPath: flow.arrangementCount(.growing)])
            growingBoundingSize = .infinity
        } else {
            growingTracks = [GridTrack](repeating: .fr(1), count: arrangement[keyPath: flow.arrangementCount(.growing)])
            growingBoundingSize = boundingSize[keyPath: flow.size(.growing)]
        }
        
        let growingTracksSizes: [CGFloat] = self.calculateTrackSizes(position: position,
                                                                     arrangement: arrangement,
                                                                     boundingSize: growingBoundingSize,
                                                                     tracks: growingTracks,
                                                                     flow: flow,
                                                                     dimension: .growing)
        
        /// 2. Calculate fixed track sizes
        let fixedTracksSizes = self.calculateTrackSizes(position: position,
                                                        arrangement: arrangement,
                                                        boundingSize: boundingSize[keyPath: flow.size(.fixed)],
                                                        tracks: tracks,
                                                        flow: flow,
                                                        dimension: .fixed)
        /// 4. Position items using calculated track sizes
        var newPositions: [PositionedItem] = []
        
        for positionedItem in position.items {
            guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
            let itemGrowingSize: CGFloat
            let growingPosition: CGFloat
            
            switch contentMode {
            case .fill:
                let growingSize = boundingSize[keyPath: flow.size(.growing)] / CGFloat(arrangement[keyPath: flow.arrangementCount(.growing)])
                itemGrowingSize = growingSize * CGFloat(arrangedItem[keyPath: flow.arrangedItemCount(.growing)])
                growingPosition = growingSize * CGFloat(arrangedItem.startIndex[keyPath: flow.index(.growing)])
            case .scroll:
                itemGrowingSize = (arrangedItem.startIndex[keyPath: flow.index(.growing)]...arrangedItem.endIndex[keyPath: flow.index(.growing)]).reduce(0, { result, index in
                    return result + growingTracksSizes[index]
                })
                let centringCorrection = (itemGrowingSize - positionedItem.bounds.size[keyPath: flow.size(.growing)]) / 2
                growingPosition = (0..<arrangedItem.startIndex[keyPath: flow.index(.growing)]).reduce(0, { result, index in
                    return result + growingTracksSizes[index]
                }) + centringCorrection
            }

            let fixedTrackStart = fixedTracksSizes[0..<arrangedItem.startIndex[keyPath: flow.index(.fixed)]].reduce(0, +)
            let fixedTrackSize = fixedTracksSizes[arrangedItem.startIndex[keyPath: flow.index(.fixed)]...arrangedItem.endIndex[keyPath: flow.index(.fixed)]].reduce(0, +)
            
            var newBounds = CGRect.zero
            newBounds.size[keyPath: flow.size(.growing)] = itemGrowingSize.rounded()
            newBounds.size[keyPath: flow.size(.fixed)] = fixedTrackSize.rounded()
            newBounds.origin[keyPath: flow.cgPointIndex(.growing)] = growingPosition.rounded()
            newBounds.origin[keyPath: flow.cgPointIndex(.fixed)] = fixedTrackStart.rounded()

            newPositions.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
        }
        
        let totalGrowingSize = growingTracksSizes.reduce(0, +)
        let totalFixedSize = fixedTracksSizes.reduce(0, +)
        var totalSize = CGSize.zero
        totalSize[keyPath: flow.size(.fixed)] = totalFixedSize.rounded()
        totalSize[keyPath: flow.size(.growing)] = totalGrowingSize.rounded()
        return PositionsPreference(items: newPositions, size: totalSize)
    }
    
    private func calculateTrackSizes(position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGFloat, tracks: [GridTrack], flow: GridFlow, dimension: GridFlowDimension) -> [CGFloat] {
        /// 1. Initialize sizes
        var growingTracksSizes: [PositionedTrack] =
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

        /// 2. Resolve Intrinsic Track Sizes
        
        /// 2.1. Size tracks to fit non-spanning items
        for (trackIndex, _) in growingTracksSizes.enumerated().filter({ $0.element.track.isIntrinsic }) {
            let arrangedNoSpanItems = arrangement.items.filter {
                ($0.startIndex[keyPath: flow.index(dimension)] == trackIndex) && ($0.span[keyPath: flow.spanIndex(dimension)] == 1)
            }
            let positionedNoSpanItems = arrangedNoSpanItems.compactMap { position[$0] }
            let maxSize = positionedNoSpanItems
                .map(\.bounds.size)
                .map { $0[keyPath: flow.size(dimension)] }
                .max()
            
            growingTracksSizes[trackIndex].baseSize = maxSize ?? growingTracksSizes[trackIndex].baseSize
        }
        
        /// 2.2. Increase sizes to accommodate spanning items
        let arrangedSpannedItems = arrangement.items
            .filter { $0.span[keyPath: flow.spanIndex(dimension)] > 1 }
        
        var spansMap: [Int: [ArrangedItem]] = [:]
        arrangedSpannedItems.forEach { arrangedItem in
            let items = spansMap[arrangedItem.span[keyPath: flow.spanIndex(dimension)]] ?? []
            spansMap[arrangedItem.span[keyPath: flow.spanIndex(dimension)]] = items + [arrangedItem]
        }
        
        for span in spansMap.keys.sorted(by: <) {
            var plannedIncreases = [CGFloat?](repeating: 0, count: growingTracksSizes.count)
            for arrangedItem in spansMap[span] ?? [] {
                let start = arrangedItem.startIndex[keyPath: flow.index(dimension)]
                let end = arrangedItem.endIndex[keyPath: flow.index(dimension)]
                
                ///Consider the items that do not span a track with a flexible size
                if (tracks[start...end].contains { $0.isFlexible }) { continue }
                
                let trackSizes = growingTracksSizes[start...end].map(\.baseSize).reduce(0, +)
                let itemSize = position[arrangedItem]?.bounds.size[keyPath: flow.size(dimension)]
                let spaceToDistribute = max(0, (itemSize ?? 0) - trackSizes)
                (start...end).forEach {
                    let plannedIncrease = plannedIncreases[$0] ?? 0
                    plannedIncreases[$0] = max(plannedIncrease, spaceToDistribute / CGFloat(span))
                }
            }
            
            plannedIncreases = plannedIncreases.map { ($0?.rounded() ?? 0) > 0.0 ? $0?.rounded() : nil }

            let existingSizes = growingTracksSizes.map(\.baseSize).reduce(0, +)
            let totalPlannedIncrease = plannedIncreases.compactMap({ $0 }).reduce(0, +)
            let freeSpace = max(0, boundingSize - existingSizes)
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
                growingTracksSizes[index].baseSize += plannedIncrease
            }
        }
        
        /// 3. Expand Flexible Tracks
        let totalConstsSize = growingTracksSizes.map(\.baseSize).reduce(0, +)
        let fractionsCount: CGFloat = growingTracksSizes.reduce(0) { result, positionedTrack in
            if case .fr(let fraction) = positionedTrack.track {
                return result + fraction
            }
            return result
        }

        let freeSpace = max(0, boundingSize - totalConstsSize)
        let fractionValue = max(0, freeSpace / fractionsCount)
        
        for (trackIndex, positionedTrack) in growingTracksSizes.enumerated() {
            if case .fr(let fraction) = positionedTrack.track {
                let baseSize = growingTracksSizes[trackIndex].baseSize
                growingTracksSizes[trackIndex].baseSize = max(fraction * fractionValue, baseSize)
            }
        }

        return growingTracksSizes.map(\.baseSize)
    }
}

extension GridIndex {
    fileprivate func nextIndex(tracksCount: Int, flow: GridFlow) -> GridIndex {
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
