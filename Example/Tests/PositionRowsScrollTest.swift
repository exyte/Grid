//
//  PositionRowsScrollTest.swift
//  ExyteGridTests
//
//  Created by Denis Obukhov on 13.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import XCTest
import SwiftUI
@testable import ExyteGrid

class PositionRowsScrollTest: XCTestCase {

    private struct MockPositioner: LayoutPositioning {}
    private let positioner = MockPositioner()
    private let mockView = AnyView(EmptyView())
    
    func testScrollModeColumnsFlowStage1() throws {
        let gridItems = [
            GridItem(self.mockView, id: AnyHashable(0)),
            GridItem(self.mockView, id: AnyHashable(1)),
            GridItem(self.mockView, id: AnyHashable(2)),
            GridItem(self.mockView, id: AnyHashable(3)),
            GridItem(self.mockView, id: AnyHashable(4))
        ]
        
        let positionedItems: [PositionedItem] = [
            PositionedItem(bounds: CGRect(x: 0.0, y: -178.0, width: 250.0, height: 228.5), gridItem: gridItems[0]),
            PositionedItem(bounds: CGRect(x: 0.0, y: -178.0, width: 251.5, height: 40.5), gridItem: gridItems[1]),
            PositionedItem(bounds: CGRect(x: 0.0, y: -178.0, width: 210.0, height: 316.5), gridItem: gridItems[2]),
            PositionedItem(bounds: CGRect(x: 0.0, y: -178.0, width: 600.0, height: 84.5), gridItem: gridItems[3]),
            PositionedItem(bounds: CGRect(x: 0.0, y: -178.0, width: 300.0, height: 162.5), gridItem: gridItems[4])
        ]
        
        let position = PositionsPreference(items: positionedItems, size: nil)
        let arrangedItems: [ArrangedItem] = [
            ArrangedItem(gridItem: gridItems[0], startIndex: [0, 0], endIndex: [0, 0]),
            ArrangedItem(gridItem: gridItems[1], startIndex: [0, 1], endIndex: [0, 1]),
            ArrangedItem(gridItem: gridItems[2], startIndex: [1, 0], endIndex: [1, 1]),
            ArrangedItem(gridItem: gridItems[3], startIndex: [1, 2], endIndex: [2, 2]),
            ArrangedItem(gridItem: gridItems[4], startIndex: [2, 0], endIndex: [4, 0])
        ]
        let arrangement = LayoutArrangement(columnsCount: 5, rowsCount: 3, items: arrangedItems)
        
        let positions = self.positioner.reposition(position,
                                                   arrangement: arrangement,
                                                   boundingSize: CGSize(width: 375.0, height: 647.0),
                                                   tracks: [.fr(1), .fitContent, .fitContent],
                                                   contentMode: .scroll,
                                                   flow: .columns)
        
        let referencePositionedItems = [
            PositionedItem(bounds: CGRect(x: 1.0, y: 0.0, width: 252.0, height: 522.0), gridItem: gridItems[0]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 522.0, width: 252.0, height: 41.0), gridItem: gridItems[1]),
            PositionedItem(bounds: CGRect(x: 349.0, y: 0.0, width: 405.0, height: 563.0), gridItem: gridItems[2]),
            PositionedItem(bounds: CGRect(x: 269.0, y: 563.0, width: 635.0, height: 85.0), gridItem: gridItems[3]),
            PositionedItem(bounds: CGRect(x: 657.0, y: 0.0, width: 300.0, height: 522.0), gridItem: gridItems[4])
        ]
        
        let referencePosition = PositionsPreference(items: referencePositionedItems, size: CGSize(width: 957.0, height: 647.0))
        
        XCTAssertEqual(positions, referencePosition)
    }
    
    func testScrollModeColumnsFlowStage2() throws {
        let gridItems = [
            GridItem(self.mockView, id: AnyHashable(0)),
            GridItem(self.mockView, id: AnyHashable(1)),
            GridItem(self.mockView, id: AnyHashable(2)),
            GridItem(self.mockView, id: AnyHashable(3)),
            GridItem(self.mockView, id: AnyHashable(4))
        ]
        
        let positionedItems: [PositionedItem] = [
            PositionedItem(bounds: CGRect(x: -177.5, y: -197.0, width: 250.0, height: 228.5), gridItem: gridItems[0]),
            PositionedItem(bounds: CGRect(x: -178.5, y: 178.5, width: 251.5, height: 40.5), gridItem: gridItems[1]),
            PositionedItem(bounds: CGRect(x: 170.5, y: -220.5, width: 210.0, height: 316.5), gridItem: gridItems[2]),
            PositionedItem(bounds: CGRect(x: 90.5, y: 219.5, width: 610.0, height: 84.5), gridItem: gridItems[3]),
            PositionedItem(bounds: CGRect(x: 478.5, y: -164.0, width: 300.0, height: 162.5), gridItem: gridItems[4])
        ]
        
        let position = PositionsPreference(items: positionedItems, size: nil)
        let arrangedItems: [ArrangedItem] = [
            ArrangedItem(gridItem: gridItems[0], startIndex: [0, 0], endIndex: [0, 0]),
            ArrangedItem(gridItem: gridItems[1], startIndex: [0, 1], endIndex: [0, 1]),
            ArrangedItem(gridItem: gridItems[2], startIndex: [1, 0], endIndex: [1, 1]),
            ArrangedItem(gridItem: gridItems[3], startIndex: [1, 2], endIndex: [2, 2]),
            ArrangedItem(gridItem: gridItems[4], startIndex: [2, 0], endIndex: [4, 0])
        ]
        let arrangement = LayoutArrangement(columnsCount: 5, rowsCount: 3, items: arrangedItems)
        
        let positions = self.positioner.reposition(position,
                                                   arrangement: arrangement,
                                                   boundingSize: CGSize(width: 375.0, height: 647.0),
                                                   tracks: [.fr(1), .fitContent, .fitContent],
                                                   contentMode: .scroll,
                                                   flow: .columns)
        
        let referencePositionedItems = [
            PositionedItem(bounds: CGRect(x: 1.0, y: 0.0, width: 252.0, height: 522.0), gridItem: gridItems[0]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 522.0, width: 252.0, height: 41.0), gridItem: gridItems[1]),
            PositionedItem(bounds: CGRect(x: 352.0, y: 0.0, width: 410.0, height: 563.0), gridItem: gridItems[2]),
            PositionedItem(bounds: CGRect(x: 268.0, y: 563.0, width: 643.0, height: 85.0), gridItem: gridItems[3]),
            PositionedItem(bounds: CGRect(x: 661.0, y: 0.0, width: 299.0, height: 522.0), gridItem: gridItems[4])
        ]
        
        let referencePosition = PositionsPreference(items: referencePositionedItems, size: CGSize(width: 961.0, height: 647.0))
        
        XCTAssertEqual(positions, referencePosition)
    }
    
}
