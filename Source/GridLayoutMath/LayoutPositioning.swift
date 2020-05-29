//
//  LayoutPositioning.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 14.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import CoreGraphics

protocol LayoutPositioning {
    /// Recalculates positions based on layout arrangement and bounding size
    /// - Parameters:
    ///   - position: Items to reposition
    ///   - arrangement: Previously calculated arrangement
    ///   - boundingSize: Bounding size
    ///   - tracks: Sizes of tracks
    ///   - contentMode: Where the content will be scrolled or filled inside a grid
    ///   - flow: Distribution order of grid items
    func reposition(_ positions: PositionsPreference) -> PositionsPreference
}

private struct PositionedTrack {
    let track: GridTrack
    var baseSize: CGFloat
}

extension LayoutPositioning {
    func reposition(_ positions: PositionsPreference) -> PositionsPreference {
        guard let environment = positions.environment else {
            fatalError("Environment have to be defined")
        }
        let flow = environment.flow
        let arrangement = environment.arrangement
        let boundingSize = environment.boundingSize
        let tracks = environment.tracks

        /// 1. Calculate growing track sizes as max of all the items within a track
        let growingTracks: [GridTrack]
        let growingBoundingSize: CGFloat
        if environment.contentMode == .scroll {
            growingTracks = [GridTrack](repeating: .fit, count: arrangement[keyPath: flow.arrangementCount(.growing)])
            growingBoundingSize = .infinity
        } else {
            growingTracks = [GridTrack](repeating: .fr(1), count: arrangement[keyPath: flow.arrangementCount(.growing)])
            growingBoundingSize = boundingSize[keyPath: flow.size(.growing)]
        }
        
        let growingTracksSizes: [CGFloat] = self.calculateTrackSizes(position: positions,
                                                                     boundingSize: growingBoundingSize,
                                                                     tracks: growingTracks,
                                                                     dimension: .growing)
        
        /// 2. Calculate fixed track sizes
        let fixedTracksSizes = self.calculateTrackSizes(position: positions,
                                                        boundingSize: boundingSize[keyPath: flow.size(.fixed)],
                                                        tracks: tracks,
                                                        dimension: .fixed)
        return positionedItems(positions: positions, growingTracksSizes: growingTracksSizes, fixedTracksSizes: fixedTracksSizes)
    }
    
    private func calculateTrackSizes(position: PositionsPreference, boundingSize: CGFloat,
                                     tracks: [GridTrack], dimension: GridFlowDimension) -> [CGFloat] {
        guard let environment = position.environment else { return [] }
        let flow = environment.flow
        let arrangement = environment.arrangement
        
        /// 1. Initialize sizes
        var growingTracksSizes: [PositionedTrack] =
            tracks.map { track in
                switch track {
                case .fr:
                    return PositionedTrack(track: track, baseSize: 0)
                case .pt(let size):
                    return PositionedTrack(track: track, baseSize: CGFloat(size))
                case .fit:
                    return PositionedTrack(track: track, baseSize: 0)
                }
        }
        
        /// 2. Resolve Intrinsic Track Sizes
        /// 2.1. Size tracks to fit non-spanning items
        self.sizeToFitNonSpanning(growingTracksSizes: &growingTracksSizes, arrangement: arrangement,
                                  flow: flow, dimension: dimension, position: position)
        
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
                    else { continue }
                    plannedIncreases[index] = plannedIncrease - normalizedIncrease * fractionValue
                }
            }

            for (index, plannedIncrease) in plannedIncreases.enumerated() {
                guard let plannedIncrease = plannedIncrease else { continue }
                growingTracksSizes[index].baseSize += plannedIncrease
            }
        }
        
        self.expandFlexibleTracks(&growingTracksSizes, boundingSize)

        return growingTracksSizes.map(\.baseSize)
    }
    
    private func positionedItems(positions: PositionsPreference, growingTracksSizes: [CGFloat], fixedTracksSizes: [CGFloat]) -> PositionsPreference {
        /// 4. Position items using calculated track sizes
        guard let environment = positions.environment else { return PositionsPreference.default }
        let flow = environment.flow
        let arrangement = environment.arrangement
        let boundingSize = environment.boundingSize
        
        var newPositions: [PositionedItem] = []
        
        for positionedItem in positions.items {
            guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
            let itemGrowingSize: CGFloat
            let growingPosition: CGFloat
            
            switch environment.contentMode {
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
            newBounds.size[keyPath: flow.size(.growing)] = itemGrowingSize
            newBounds.size[keyPath: flow.size(.fixed)] = fixedTrackSize
            newBounds.origin[keyPath: flow.cgPointIndex(.growing)] = growingPosition
            newBounds.origin[keyPath: flow.cgPointIndex(.fixed)] = fixedTrackStart
            newBounds = newBounds.integral
            newPositions.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
        }
        
        let totalGrowingSize = growingTracksSizes.reduce(0, +)
        let totalFixedSize = fixedTracksSizes.reduce(0, +)
        var totalSize = CGSize.zero
        
        totalSize[keyPath: flow.size(.fixed)] = totalFixedSize.rounded()
        totalSize[keyPath: flow.size(.growing)] = totalGrowingSize.rounded()
        return PositionsPreference(items: newPositions, size: totalSize)
    }
    
    private func sizeToFitNonSpanning(growingTracksSizes: inout [PositionedTrack], arrangement: LayoutArrangement,
                                      flow: GridFlow, dimension: GridFlowDimension, position: PositionsPreference) {
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
    }
    
    private func expandFlexibleTracks(_ growingTracksSizes: inout [PositionedTrack], _ boundingSize: CGFloat) {
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
    }
}
