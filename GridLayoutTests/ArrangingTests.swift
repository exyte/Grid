//
//  ArrangingTests.swift
//  GridLayout
//
//  Created by Denis Obukhov on 06.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import XCTest
import SwiftUI
@testable import GridLayout

class ArrangingTests: XCTestCase {
    
    private struct MockArranger: LayoutArranging {}
    private let arranger = MockArranger()
    
    private let gridItems = (0..<7).map { GridItem(AnyView(EmptyView()), id: AnyHashable($0)) }
    
    private lazy var spanPreferences = [
        SpanPreference(item: gridItems[0], span: GridSpan(row: 1, column: 3)),
        SpanPreference(item: gridItems[1], span: GridSpan(row: 2, column: 2)),
        SpanPreference(item: gridItems[2], span: GridSpan(row: 1, column: 1)),
        SpanPreference(item: gridItems[3], span: GridSpan(row: 1, column: 1)),
        SpanPreference(item: gridItems[4], span: GridSpan(row: 2, column: 1)),
        SpanPreference(item: gridItems[5], span: GridSpan(row: 3, column: 2)),
        SpanPreference(item: gridItems[6], span: GridSpan(row: 3, column: 1))
    ]
    
    private let fixedPerfomanceTracksCount = 4
    
    private lazy var perfomancePreferences: [SpanPreference] = {
        srand48(0)
        let randomSpan = {
            return max(1, Int(drand48() * 100) % self.fixedPerfomanceTracksCount)
        }
        
        let gridItems = (0..<100).map { GridItem(AnyView(EmptyView()), id: AnyHashable($0)) }
        return gridItems.map {
            SpanPreference(item: $0, span: GridSpan(row: randomSpan(), column: randomSpan()))
        }
    }()

    func testArrangementSparseColumns() throws {
        let arrangement = arranger.arrange(spanPreferences: spanPreferences,
                                           fixedTracksCount: 4,
                                           flow: .columns,
                                           packing: .sparse)
 
        XCTAssertEqual(arrangement, LayoutArrangement(columnsCount: 4, rowsCount: 6, items: [
            ArrangedItem(gridItem: gridItems[0],
                         startIndex: GridIndex.zero,
                         endIndex: GridIndex(row: 0, column: 2)),
            ArrangedItem(gridItem: gridItems[1],
                         startIndex: GridIndex(row: 1, column: 0),
                         endIndex: GridIndex(row: 2, column: 1)),
            ArrangedItem(gridItem: gridItems[2],
                         startIndex: GridIndex(row: 1, column: 2),
                         endIndex: GridIndex(row: 1, column: 2)),
            ArrangedItem(gridItem: gridItems[3],
                         startIndex: GridIndex(row: 1, column: 3),
                         endIndex: GridIndex(row: 1, column: 3)),
            ArrangedItem(gridItem: gridItems[4],
                         startIndex: GridIndex(row: 2, column: 2),
                         endIndex: GridIndex(row: 3, column: 2)),
            ArrangedItem(gridItem: gridItems[5],
                         startIndex: GridIndex(row: 3, column: 0),
                         endIndex: GridIndex(row: 5, column: 1)),
            ArrangedItem(gridItem: gridItems[6],
                         startIndex: GridIndex(row: 3, column: 3),
                         endIndex: GridIndex(row: 5, column: 3))
        ]))
    }
    
    func testArrangementDenseColumns() throws {
        let arrangement = arranger.arrange(spanPreferences: spanPreferences,
                                           fixedTracksCount: 4,
                                           flow: .columns,
                                           packing: .dense)

        XCTAssertEqual(arrangement, LayoutArrangement(columnsCount: 4, rowsCount: 6, items: [
            ArrangedItem(gridItem: gridItems[0],
                         startIndex: GridIndex.zero,
                         endIndex: GridIndex(row: 0, column: 2)),
            ArrangedItem(gridItem: gridItems[1],
                         startIndex: GridIndex(row: 1, column: 0),
                         endIndex: GridIndex(row: 2, column: 1)),
            ArrangedItem(gridItem: gridItems[2],
                         startIndex: GridIndex(row: 0, column: 3),
                         endIndex: GridIndex(row: 0, column: 3)),
            ArrangedItem(gridItem: gridItems[3],
                         startIndex: GridIndex(row: 1, column: 2),
                         endIndex: GridIndex(row: 1, column: 2)),
            ArrangedItem(gridItem: gridItems[4],
                         startIndex: GridIndex(row: 1, column: 3),
                         endIndex: GridIndex(row: 2, column: 3)),
            ArrangedItem(gridItem: gridItems[5],
                         startIndex: GridIndex(row: 3, column: 0),
                         endIndex: GridIndex(row: 5, column: 1)),
            ArrangedItem(gridItem: gridItems[6],
                         startIndex: GridIndex(row: 2, column: 2),
                         endIndex: GridIndex(row: 4, column: 2))
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
