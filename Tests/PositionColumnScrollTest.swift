//
//  PositionColumnScrollTest.swift
//  GridTests
//
//  Created by Denis Obukhov on 13.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import XCTest
import SwiftUI

#if os(iOS) || os(watchOS) || os(tvOS)
@testable import Grid
#else
@testable import GridMac
#endif

class PositionColumnScrollTest: XCTestCase {

    private struct MockPositioner: LayoutPositioning {}
    private let positioner = MockPositioner()
    private let mockView = AnyView(EmptyView())
    
    func testScrollModeColumnsFlowStage1() throws {
        let gridElements = [
            GridElement(self.mockView, id: AnyHashable(0)),
            GridElement(self.mockView, id: AnyHashable(1)),
            GridElement(self.mockView, id: AnyHashable(2)),
            GridElement(self.mockView, id: AnyHashable(3)),
            GridElement(self.mockView, id: AnyHashable(4))
        ]
        
        let positionedItems: [PositionedItem] = [
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 358.5, height: 162.5), gridElement: gridElements[0]),
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 70.00, height: 140.5), gridElement: gridElements[1]),
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 100.0, height: 360.5), gridElement: gridElements[2]),
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 358.5, height: 106.5), gridElement: gridElements[3]),
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 358.5, height: 128.5), gridElement: gridElements[4])
        ]
        
        let arrangedItems: [ArrangedItem] = [
            ArrangedItem(gridElement: gridElements[0], startIndex: [0, 0], endIndex: [0, 0]),
            ArrangedItem(gridElement: gridElements[1], startIndex: [1, 0], endIndex: [1, 0]),
            ArrangedItem(gridElement: gridElements[2], startIndex: [2, 0], endIndex: [2, 1]),
            ArrangedItem(gridElement: gridElements[3], startIndex: [0, 1], endIndex: [1, 1]),
            ArrangedItem(gridElement: gridElements[4], startIndex: [0, 2], endIndex: [2, 2])
        ]
        let arrangement = LayoutArrangement(columnsCount: 3, rowsCount: 3, items: arrangedItems)

        let task = PositioningTask(items: positionedItems,
                                   arrangement: arrangement,
                                   boundingSize: CGSize(width: 375.0, height: 647.0),
                                   tracks: [.fr(1), .fit, .fit],
                                   contentMode: .scroll,
                                   flow: .rows)
        
        let resultPositions = self.positioner.reposition(task)
        
        let referencePositionedItems = [
            PositionedItem(bounds: CGRect(x: 0.0, y: 23.0, width: 205.0, height: 209.0), gridElement: gridElements[0]),
            PositionedItem(bounds: CGRect(x: 205.0, y: 34.0, width: 70.00, height: 209.0), gridElement: gridElements[1]),
            PositionedItem(bounds: CGRect(x: 275.0, y: 0.0, width: 100.0, height: 362.0), gridElement: gridElements[2]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 231.0, width: 275.0, height: 153.0), gridElement: gridElements[3]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 361.0, width: 375.0, height: 129.0), gridElement: gridElements[4])
        ]
        let referencePositions = PositionedLayout(items: referencePositionedItems, totalSize: CGSize(width: 375, height: 490))

        XCTAssertEqual(resultPositions, referencePositions)
    }
    
    func testScrollModeColumnsFlowStage2() throws {
        let gridElements = [
            GridElement(self.mockView, id: AnyHashable(0)),
            GridElement(self.mockView, id: AnyHashable(1)),
            GridElement(self.mockView, id: AnyHashable(2)),
            GridElement(self.mockView, id: AnyHashable(3)),
            GridElement(self.mockView, id: AnyHashable(4))
        ]
        
        let positionedItems: [PositionedItem] = [
            PositionedItem(bounds: CGRect(x: -187.5, y: 3.0, width: 205.0, height: 316.5), gridElement: gridElements[0]),
            PositionedItem(bounds: CGRect(x: 17.5, y: 14.0, width: 70.00, height: 140.5), gridElement: gridElements[1]),
            PositionedItem(bounds: CGRect(x: 87.5, y: -20.0, width: 100.0, height: 382.5), gridElement: gridElements[2]),
            PositionedItem(bounds: CGRect(x: -185.5, y: 212.0, width: 271.5, height: 150.5), gridElement: gridElements[3]),
            PositionedItem(bounds: CGRect(x: -179.0, y: 341.0, width: 358.5, height: 128.5), gridElement: gridElements[4])
        ]
        
        let arrangedItems: [ArrangedItem] = [
            ArrangedItem(gridElement: gridElements[0], startIndex: [0, 0], endIndex: [0, 0]),
            ArrangedItem(gridElement: gridElements[1], startIndex: [1, 0], endIndex: [1, 0]),
            ArrangedItem(gridElement: gridElements[2], startIndex: [2, 0], endIndex: [2, 1]),
            ArrangedItem(gridElement: gridElements[3], startIndex: [0, 1], endIndex: [1, 1]),
            ArrangedItem(gridElement: gridElements[4], startIndex: [0, 2], endIndex: [2, 2])
        ]
        let arrangement = LayoutArrangement(columnsCount: 3, rowsCount: 3, items: arrangedItems)
        
        let task = PositioningTask(items: positionedItems,
                                   arrangement: arrangement,
                                   boundingSize: CGSize(width: 375.0, height: 647.0),
                                   tracks: [.fr(1), .fit, .fit],
                                   contentMode: .scroll,
                                   flow: .rows)

        let resultPositions = self.positioner.reposition(task)
        
        let referencePositionedItems = [
            PositionedItem(bounds: CGRect(x: 0.0, y: 0.0, width: 205.0, height: 317.0), gridElement: gridElements[0]),
            PositionedItem(bounds: CGRect(x: 205.0, y: 88.0, width: 70.00, height: 317.0), gridElement: gridElements[1]),
            PositionedItem(bounds: CGRect(x: 275.0, y: 42.0, width: 100.0, height: 468.0), gridElement: gridElements[2]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 316.0, width: 275.0, height: 151.0), gridElement: gridElements[3]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 467.0, width: 375.0, height: 129.0), gridElement: gridElements[4])
        ]
        
        let referencePosition = PositionedLayout(items: referencePositionedItems, totalSize: CGSize(width: 375, height: 596))
        
        XCTAssertEqual(resultPositions, referencePosition)
    }
    
    func testScrollModeColumnsFlowStage3() throws {
        let gridElements = [
            GridElement(self.mockView, id: AnyHashable(0)),
            GridElement(self.mockView, id: AnyHashable(1)),
            GridElement(self.mockView, id: AnyHashable(2)),
            GridElement(self.mockView, id: AnyHashable(3)),
            GridElement(self.mockView, id: AnyHashable(4))
        ]
        
        let positionedItems: [PositionedItem] = [
            PositionedItem(bounds: CGRect(x: 0.0, y: 0.0, width: 205.0, height: 316.5), gridElement: gridElements[0]),
            PositionedItem(bounds: CGRect(x: 205.0, y: 88.0, width: 70.00, height: 140.5), gridElement: gridElements[1]),
            PositionedItem(bounds: CGRect(x: 275.0, y: 42.0, width: 100.0, height: 382.5), gridElement: gridElements[2]),
            PositionedItem(bounds: CGRect(x: 2.0, y: 317.0, width: 271.5, height: 150.5), gridElement: gridElements[3]),
            PositionedItem(bounds: CGRect(x: 8.5, y: 467.0, width: 358.5, height: 128.5), gridElement: gridElements[4])
        ]
        
        let arrangedItems: [ArrangedItem] = [
            ArrangedItem(gridElement: gridElements[0], startIndex: [0, 0], endIndex: [0, 0]),
            ArrangedItem(gridElement: gridElements[1], startIndex: [1, 0], endIndex: [1, 0]),
            ArrangedItem(gridElement: gridElements[2], startIndex: [2, 0], endIndex: [2, 1]),
            ArrangedItem(gridElement: gridElements[3], startIndex: [0, 1], endIndex: [1, 1]),
            ArrangedItem(gridElement: gridElements[4], startIndex: [0, 2], endIndex: [2, 2])
        ]
        let arrangement = LayoutArrangement(columnsCount: 3, rowsCount: 3, items: arrangedItems)
        
        let task = PositioningTask(items: positionedItems,
                                   arrangement: arrangement,
                                   boundingSize: CGSize(width: 375.0, height: 647.0),
                                   tracks: [.fr(1), .fit, .fit],
                                   contentMode: .scroll,
                                   flow: .rows)

        let resultPpositions = self.positioner.reposition(task)
        
        let referencePositionedItems = [
            PositionedItem(bounds: CGRect(x: 0.0, y: 0.0, width: 205.0, height: 317.0), gridElement: gridElements[0]),
            PositionedItem(bounds: CGRect(x: 205.0, y: 88.0, width: 70.00, height: 317.0), gridElement: gridElements[1]),
            PositionedItem(bounds: CGRect(x: 275.0, y: 42.0, width: 100.0, height: 468.0), gridElement: gridElements[2]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 316.0, width: 275.0, height: 151.0), gridElement: gridElements[3]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 467.0, width: 375.0, height: 129.0), gridElement: gridElements[4])
        ]
        
        let referencePosition = PositionedLayout(items: referencePositionedItems, totalSize: CGSize(width: 375, height: 596))
        
        XCTAssertEqual(resultPpositions, referencePosition)
    }
}
