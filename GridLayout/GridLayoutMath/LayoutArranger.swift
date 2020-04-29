//
//  LayoutArranger.swift
//  GridLayout
//
//  Created by Denis Obukhov on 16.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation
import CoreGraphics

protocol LayoutArranger {
    /// Arranges grid items into layout arrangement that specifies relations between abstract position in grid view and specific item
    /// - Parameters:
    ///   - items: Grid items to arrange. They could specify row and columns spans
    ///   - columnsCount: Total count of columns in grid view
    func arrange(spanPreferences: [SpanPreference], columnsCount: Int) -> LayoutArrangement
    
    /// Recalculates positions based on layout arrangement and bounding size
    /// - Parameters:
    ///   - items: Items to reposition
    ///   - arrangement: Previously calculated arrangement
    ///   - size: Bounding size
    ///   - tracks: Sizes of tracks
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode) -> PositionsPreference
}

class LayoutArrangerImpl: LayoutArranger {
    
    func arrange(spanPreferences: [SpanPreference], columnsCount: Int) -> LayoutArrangement {
        guard columnsCount > 0 else { return LayoutArrangement(columnsCount: columnsCount, rowsCount: 0, items: []) }
            
        var result: [ArrangedItem] = []
        var occupiedPoints: [GridPoint] = []
        
        var lastPoint: GridPoint = .zero
        var rowsCount = 0

        for spanPreference in spanPreferences {
            guard
                spanPreference.span.column <= columnsCount,
                let gridItem = spanPreference.item
            else {
                continue
            } // TODO: Reduce span
            
            while occupiedPoints.contains(lastPoint, rowSpan: spanPreference.span.row, columnSpan: spanPreference.span.column)
                || lastPoint.column + spanPreference.span.column > columnsCount {
                    lastPoint = lastPoint.nextPoint(columnsCount: columnsCount)
            }

            for row in lastPoint.row..<lastPoint.row + spanPreference.span.row {
                for column in lastPoint.column..<lastPoint.column + spanPreference.span.column {
                    occupiedPoints.append(GridPoint(row: row, column: column))
                }
            }
            
            let startPoint = lastPoint
            let endPoint = GridPoint(row: startPoint.row + spanPreference.span.row - 1,
                                           column: startPoint.column + spanPreference.span.column - 1)

            let arrangedItem = ArrangedItem(gridItem: gridItem, startPoint: startPoint, endPoint: endPoint)
            rowsCount = max(rowsCount, arrangedItem.endPoint.row + 1)
            result.append(arrangedItem)
            lastPoint = lastPoint.nextPoint(columnsCount: columnsCount)
        }
        
        return LayoutArrangement(columnsCount: columnsCount, rowsCount: rowsCount, items: result)
    }
    
    func reposition(_ position: PositionsPreference, arrangement: LayoutArrangement, boundingSize: CGSize, tracks: [TrackSize], contentMode: GridContentMode) -> PositionsPreference {
        let rowSizes: [CGFloat] = self.calculateSizes(position: position, arrangement: arrangement, contentMode: contentMode)
        let columnSizes = self.calculateSizes(tracks: tracks, boundingLength: boundingSize.width)
        var newPositions: [PositionedItem] = []
        
        for positionedItem in position.items {
            guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
            let rowSize = boundingSize.height / CGFloat(arrangement.rowsCount)
            
            let itemHeight: CGFloat
            let positionY: CGFloat
            
            switch contentMode {
            case .fill:
                itemHeight = rowSize * CGFloat(arrangedItem.rowsCount)
                positionY = rowSize * CGFloat(arrangedItem.startPoint.row)
            case .scroll:
                itemHeight = (arrangedItem.startPoint.row...arrangedItem.endPoint.row).reduce(0, { result, row in
                    return result + rowSizes[row]
                })
                let centringYCorrection = (itemHeight - positionedItem.bounds.height) / 2
                positionY = (0..<arrangedItem.startPoint.row).reduce(0, { result, row in
                    return result + rowSizes[row]
                }) + centringYCorrection
            }

            let trackStart = columnSizes[0..<arrangedItem.startPoint.column].reduce(0) { $0 + $1 }
            let trackSize = columnSizes[arrangedItem.startPoint.column...arrangedItem.endPoint.column].reduce(0) { $0 + $1 }
            
            let newBounds = CGRect(x: trackStart, y: positionY, width: trackSize, height: itemHeight)
            newPositions.append(PositionedItem(bounds: newBounds, gridItem: positionedItem.gridItem))
        }
        
        let totalHeight = rowSizes.reduce(0, { result, trackSize in
            return result + trackSize
        })

        return PositionsPreference(items: newPositions, size: CGSize(width: boundingSize.width, height: totalHeight))
    }
    
    private func calculateSizes(tracks: [TrackSize], boundingLength: CGFloat) -> [CGFloat] {
        var fractionCount = 0
        var totalConsts = 0
        
        for track in tracks {
            switch track {
            case .fr(let fraction):
                fractionCount += fraction
            case .const(let constLength):
                totalConsts += constLength
            }
        }
        
        let correctedLength = boundingLength - CGFloat(totalConsts)
        let fractionSize = correctedLength / CGFloat(fractionCount)

        return tracks.map { track in
            switch track {
            case .fr(let fraction):
                return CGFloat(fraction) * fractionSize
            case .const(let constLength):
                return CGFloat(constLength)
            }
        }
    }
    
    private func calculateSizes(position: PositionsPreference, arrangement: LayoutArrangement, contentMode: GridContentMode) -> [CGFloat] {
        var sizes: [CGFloat] = .init(repeating: 0, count: arrangement.rowsCount)
        if case .scroll = contentMode {
            for positionedItem in position.items {
                guard let arrangedItem = arrangement[positionedItem.gridItem] else { continue }
                
                let itemSelfHeight = positionedItem.bounds.height
                for index in arrangedItem.startPoint.row...arrangedItem.endPoint.row {
                    sizes[index] = max(sizes[index], itemSelfHeight / CGFloat(arrangedItem.rowsCount))
                }
            }
        }
        return sizes
    }
}

extension GridPoint {
    fileprivate func nextPoint(columnsCount: Int) -> GridPoint {
        var column = self.column
        var row = self.row
        
        column += 1
        if column >= columnsCount {
            column = 0
            row += 1
        }
        
        return GridPoint(row: row, column: column)
    }
}

extension Array where Element == GridPoint {
    fileprivate func contains(_ startPoint: GridPoint, rowSpan: Int, columnSpan: Int) -> Bool {
        for row in startPoint.row..<startPoint.row + rowSpan {
            for column in startPoint.column..<startPoint.column + columnSpan {
                if self.contains(GridPoint(row: row, column: column)) {
                    return true
                }
            }
        }
        
        return false
    }
}
