//
//  LayoutPositioning.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 14.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import CoreGraphics

protocol LayoutPositioning {
    func reposition(_ task: PositioningTask) -> PositionedLayout
}

struct PositioningTask: Equatable, Hashable {
    let items: [PositionedItem]
    var arrangement: LayoutArrangement
    var boundingSize: CGSize
    var tracks: [GridTrack]
    var contentMode: GridContentMode
    var flow: GridFlow

    subscript(arrangedItem: ArrangedItem) -> PositionedItem? {
        items.first(where: { $0.gridItem == arrangedItem.gridItem })
    }
}

struct PositionedLayout: Equatable {
    let items: [PositionedItem]
    let totalSize: CGSize?
    
    static let empty = PositionedLayout(items: [], totalSize: nil)

    subscript(gridItem: GridItem) -> PositionedItem? {
        items.first(where: { $0.gridItem == gridItem })
    }
    
    subscript(arrangedItem: ArrangedItem) -> PositionedItem? {
        items.first(where: { $0.gridItem == arrangedItem.gridItem })
    }
}

private struct PositionedTrack {
    let track: GridTrack
    var baseSize: CGFloat
}

extension LayoutPositioning {
    func reposition(_ task: PositioningTask) -> PositionedLayout {
        let flow = task.flow
        let arrangement = task.arrangement
        let boundingSize = task.boundingSize
        let tracks = task.tracks

        /// 1. Calculate growing track sizes as max of all the items within a track
        let growingTracks: [GridTrack]
        let growingBoundingSize: CGFloat
        if task.contentMode == .scroll {
            growingTracks = [GridTrack](repeating: .fit, count: arrangement[keyPath: flow.arrangementCount(.growing)])
            growingBoundingSize = .infinity
        } else {
            growingTracks = [GridTrack](repeating: .fr(1), count: arrangement[keyPath: flow.arrangementCount(.growing)])
            growingBoundingSize = boundingSize[keyPath: flow.size(.growing)]
        }
        
        let growingTracksSizes: [CGFloat] = self.calculateTrackSizes(task: task,
                                                                     boundingSize: growingBoundingSize,
                                                                     tracks: growingTracks,
                                                                     dimension: .growing)
        
        /// 2. Calculate fixed track sizes
        let fixedTracksSizes = self.calculateTrackSizes(task: task,
                                                        boundingSize: boundingSize[keyPath: flow.size(.fixed)],
                                                        tracks: tracks,
                                                        dimension: .fixed)
        return positionedItems(task: task, growingTracksSizes: growingTracksSizes, fixedTracksSizes: fixedTracksSizes)
    }
    
    private func calculateTrackSizes(task: PositioningTask, boundingSize: CGFloat,
                                     tracks: [GridTrack], dimension: GridFlowDimension) -> [CGFloat] {
        let flow = task.flow
        let arrangement = task.arrangement
        
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
                                  flow: flow, dimension: dimension, task: task)
        
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
                let itemSize = task[arrangedItem]?.bounds.size[keyPath: flow.size(dimension)]
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
    
    private func positionedItems(task: PositioningTask, growingTracksSizes: [CGFloat], fixedTracksSizes: [CGFloat]) -> PositionedLayout {
        /// 4. Position items using calculated track sizes
        let flow = task.flow
        let arrangement = task.arrangement
        let boundingSize = task.boundingSize
        
        var newPositions: [PositionedItem] = []
        
        for positionedItem in task.items {
            guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
            let itemGrowingSize: CGFloat
            let growingPosition: CGFloat
            
            switch task.contentMode {
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
        return PositionedLayout(items: newPositions, totalSize: totalSize)
    }
    
    private func sizeToFitNonSpanning(growingTracksSizes: inout [PositionedTrack], arrangement: LayoutArrangement,
                                      flow: GridFlow, dimension: GridFlowDimension, task: PositioningTask) {
        /// 2.1. Size tracks to fit non-spanning items
        for (trackIndex, _) in growingTracksSizes.enumerated().filter({ $0.element.track.isIntrinsic }) {
            let arrangedNoSpanItems = arrangement.items.filter {
                ($0.startIndex[keyPath: flow.index(dimension)] == trackIndex) && ($0.span[keyPath: flow.spanIndex(dimension)] == 1)
            }
            let positionedNoSpanItems = arrangedNoSpanItems.compactMap { task[$0] }
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
