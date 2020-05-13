//
//  PositionTests.swift
//  GridLayoutTests
//
//  Created by Denis Obukhov on 13.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import XCTest
import SwiftUI
@testable import GridLayout

class PositionTests: XCTestCase {

    private struct MockArranger: LayoutArranging {}
    private let arranger = MockArranger()
    private let mockView = AnyView(EmptyView())
    
    func testScrollModeColumnsFlow() throws {
        let gridItems = [
            GridItem(self.mockView, id: AnyHashable(0)),
            GridItem(self.mockView, id: AnyHashable(1)),
            GridItem(self.mockView, id: AnyHashable(2)),
            GridItem(self.mockView, id: AnyHashable(3)),
            GridItem(self.mockView, id: AnyHashable(4))
        ]
        
        let positionedItems: [PositionedItem] = [
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 358.5, height: 162.5), gridItem: gridItems[0]),
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 70.00, height: 140.5), gridItem: gridItems[1]),
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 100.0, height: 360.5), gridItem: gridItems[2]),
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 358.5, height: 106.5), gridItem: gridItems[3]),
            PositionedItem(bounds: CGRect(x: -179.0, y: -20.0, width: 358.5, height: 128.5), gridItem: gridItems[4])
        ]
        
        let position = PositionsPreference(items: positionedItems, size: nil)
        let arrangedItems: [ArrangedItem] = [
            ArrangedItem(gridItem: gridItems[0], startIndex: GridIndex(column: 0, row: 0), endIndex: GridIndex(column: 0, row: 0)),
            ArrangedItem(gridItem: gridItems[1], startIndex: GridIndex(column: 1, row: 0), endIndex: GridIndex(column: 1, row: 0)),
            ArrangedItem(gridItem: gridItems[2], startIndex: GridIndex(column: 2, row: 0), endIndex: GridIndex(column: 2, row: 1)),
            ArrangedItem(gridItem: gridItems[3], startIndex: GridIndex(column: 0, row: 1), endIndex: GridIndex(column: 1, row: 1)),
            ArrangedItem(gridItem: gridItems[4], startIndex: GridIndex(column: 0, row: 2), endIndex: GridIndex(column: 2, row: 2))
        ]
        let arrangement = LayoutArrangement(columnsCount: 3, rowsCount: 3, items: arrangedItems)
        
        let positions = self.arranger.reposition(position,
                                                 arrangement: arrangement,
                                                 boundingSize: CGSize(width: 375.0, height: 647.0),
                                                 tracks: [.fr(1), .fitContent, .fitContent],
                                                 contentMode: .scroll,
                                                 flow: .columns)
        
        let referencePositionedItems = [
            PositionedItem(bounds: CGRect(x: 0.0, y: 23.0, width: 205.0, height: 209.0), gridItem: gridItems[0]),
            PositionedItem(bounds: CGRect(x: 205.0, y: 34.0, width: 70.00, height: 209.0), gridItem: gridItems[1]),
            PositionedItem(bounds: CGRect(x: 275.0, y: 0.0, width: 100.0, height: 361.0), gridItem: gridItems[2]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 232.0, width: 275.0, height: 153.0), gridItem: gridItems[3]),
            PositionedItem(bounds: CGRect(x: 0.0, y: 361.0, width: 375.0, height: 129.0), gridItem: gridItems[4])
        ]
        
        let referencePosition = PositionsPreference(items: referencePositionedItems, size: CGSize(width: 375, height: 490))
        
        XCTAssertEqual(positions, referencePosition)
    }

}
