//
//  ArrangingTest.swift
//  GridLayout
//
//  Created by Denis Obukhov on 06.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import XCTest
import SwiftUI
@testable import GridLayout

class ArrangingTest: XCTestCase {
    
    private struct MockArranger: LayoutArranging {}
    private let arranger = MockArranger()
    
    private let gridItems = (0..<7).map { GridItem(AnyView(EmptyView()), id: AnyHashable($0)) }
    
    private lazy var spanPreferences = [
        SpanPreference(item: gridItems[0], span: [3, 1]),
        SpanPreference(item: gridItems[1], span: [2, 2]),
        SpanPreference(item: gridItems[2], span: [1, 1]),
        SpanPreference(item: gridItems[3], span: [1, 1]),
        SpanPreference(item: gridItems[4], span: [1, 2]),
        SpanPreference(item: gridItems[5], span: [2, 3]),
        SpanPreference(item: gridItems[6], span: [1, 3])
    ]
    
    private let fixedPerfomanceTracksCount = 4
    
    private lazy var perfomancePreferences: [SpanPreference] = {
        srand48(0)
        let randomSpan = {
            return max(1, Int(drand48() * 100) % self.fixedPerfomanceTracksCount)
        }
        
        let gridItems = (0..<100).map { GridItem(AnyView(EmptyView()), id: AnyHashable($0)) }
        return gridItems.map {
            SpanPreference(item: $0, span: [randomSpan(), randomSpan()])
        }
    }()

    func testArrangementSparseColumns() throws {
        let arrangement = arranger.arrange(spanPreferences: spanPreferences,
                                           fixedTracksCount: 4,
                                           flow: .columns,
                                           packing: .sparse)
 
        XCTAssertEqual(arrangement, LayoutArrangement(columnsCount: 4, rowsCount: 6, items: [
            ArrangedItem(gridItem: gridItems[0], startIndex: GridIndex.zero, endIndex: [2, 0]),
            ArrangedItem(gridItem: gridItems[1], startIndex: [0, 1], endIndex: [1, 2]),
            ArrangedItem(gridItem: gridItems[2], startIndex: [2, 1], endIndex: [2, 1]),
            ArrangedItem(gridItem: gridItems[3], startIndex: [3, 1], endIndex: [3, 1]),
            ArrangedItem(gridItem: gridItems[4], startIndex: [2, 2], endIndex: [2, 3]),
            ArrangedItem(gridItem: gridItems[5], startIndex: [0, 3], endIndex: [1, 5]),
            ArrangedItem(gridItem: gridItems[6], startIndex: [3, 3], endIndex: [3, 5])
        ]))
    }
    
    func testArrangementDenseColumns() throws {
        let arrangement = arranger.arrange(spanPreferences: spanPreferences,
                                           fixedTracksCount: 4,
                                           flow: .columns,
                                           packing: .dense)

        XCTAssertEqual(arrangement, LayoutArrangement(columnsCount: 4, rowsCount: 6, items: [
            ArrangedItem(gridItem: gridItems[0], startIndex: GridIndex.zero, endIndex: [2, 0]),
            ArrangedItem(gridItem: gridItems[1], startIndex: [0, 1], endIndex: [1, 2]),
            ArrangedItem(gridItem: gridItems[2], startIndex: [3, 0], endIndex: [3, 0]),
            ArrangedItem(gridItem: gridItems[3], startIndex: [2, 1], endIndex: [2, 1]),
            ArrangedItem(gridItem: gridItems[4], startIndex: [3, 1], endIndex: [3, 2]),
            ArrangedItem(gridItem: gridItems[5], startIndex: [0, 3], endIndex: [1, 5]),
            ArrangedItem(gridItem: gridItems[6], startIndex: [2, 2], endIndex: [2, 4])
        ]))
    }

    func testArrangementSparsePerformance() throws {
        let preferences = self.perfomancePreferences
        self.measure {
            _ = arranger.arrange(spanPreferences: preferences,
                                 fixedTracksCount: self.fixedPerfomanceTracksCount,
                                 flow: .columns,
                                 packing: .sparse)
        }
    }
    
    func testArrangementDensePerformance() throws {
        let preferences = self.perfomancePreferences
        self.measure {
            _ = arranger.arrange(spanPreferences: preferences,
                                 fixedTracksCount: self.fixedPerfomanceTracksCount,
                                 flow: .columns,
                                 packing: .dense)
        }
    }

}
