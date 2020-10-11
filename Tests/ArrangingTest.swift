//
//  ArrangingTest.swift
//  GridTests
//
//  Created by Denis Obukhov on 06.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import XCTest
import SwiftUI

#if os(iOS) || os(watchOS) || os(tvOS)
@testable import Grid
#else
@testable import GridMac
#endif

class ArrangingTest: XCTestCase {
    
    private struct MockArranger: LayoutArranging {}
    private let arranger = MockArranger()
    private let gridElements = (0..<7).map { GridElement(AnyView(EmptyView()), id: AnyHashable($0)) }
    private let perfomanceGridElements = (0..<100).map { GridElement(AnyView(EmptyView()), id: AnyHashable($0)) }
    private lazy var spans: [GridSpan] = [
        [3, 1],
        [2, 2],
        [1, 1],
        [1, 1],
        [1, 2],
        [2, 3],
        [1, 3]
    ]
    private let fixedPerfomanceTracksCount = 4
    
    private lazy var perfomanceSpans: [GridSpan] = {
        srand48(0)
        let randomSpan = {
            return max(1, Int(drand48() * 100) % self.fixedPerfomanceTracksCount)
        }
        
        return perfomanceGridElements.map { _ in [randomSpan(), randomSpan()] }
    }()
    
    private lazy var arrangementsInfo: [ArrangementInfo] = gridElements.enumerated().map {
        ArrangementInfo(gridElement: $1, start: .default, span: spans[$0])
    }
    
    private lazy var perfomanceArrangementsInfo: [ArrangementInfo] = gridElements.enumerated().map {
        ArrangementInfo(gridElement: $1, start: .default, span: perfomanceSpans[$0])
    }

    func testArrangementSparseRows() throws {
        let task = ArrangingTask(itemsInfo: arrangementsInfo,
                                 tracks: 4,
                                 flow: .rows,
                                 packing: .sparse)

        let arrangement = arranger.arrange(task: task)

        XCTAssertEqual(arrangement, LayoutArrangement(columnsCount: 4, rowsCount: 6, items: [
            ArrangedItem(gridElement: gridElements[0], startIndex: GridIndex.zero, endIndex: [2, 0]),
            ArrangedItem(gridElement: gridElements[1], startIndex: [0, 1], endIndex: [1, 2]),
            ArrangedItem(gridElement: gridElements[2], startIndex: [2, 1], endIndex: [2, 1]),
            ArrangedItem(gridElement: gridElements[3], startIndex: [3, 1], endIndex: [3, 1]),
            ArrangedItem(gridElement: gridElements[4], startIndex: [2, 2], endIndex: [2, 3]),
            ArrangedItem(gridElement: gridElements[5], startIndex: [0, 3], endIndex: [1, 5]),
            ArrangedItem(gridElement: gridElements[6], startIndex: [3, 3], endIndex: [3, 5])
        ]))
    }
    
    func testArrangementDenseRows() throws {
        let task = ArrangingTask(itemsInfo: arrangementsInfo,
                                 tracks: 4,
                                 flow: .rows,
                                 packing: .dense)

        let arrangement = arranger.arrange(task: task)
        
        XCTAssertEqual(arrangement, LayoutArrangement(columnsCount: 4, rowsCount: 6, items: [
            ArrangedItem(gridElement: gridElements[0], startIndex: GridIndex.zero, endIndex: [2, 0]),
            ArrangedItem(gridElement: gridElements[1], startIndex: [0, 1], endIndex: [1, 2]),
            ArrangedItem(gridElement: gridElements[2], startIndex: [3, 0], endIndex: [3, 0]),
            ArrangedItem(gridElement: gridElements[3], startIndex: [2, 1], endIndex: [2, 1]),
            ArrangedItem(gridElement: gridElements[4], startIndex: [3, 1], endIndex: [3, 2]),
            ArrangedItem(gridElement: gridElements[5], startIndex: [0, 3], endIndex: [1, 5]),
            ArrangedItem(gridElement: gridElements[6], startIndex: [2, 2], endIndex: [2, 4])
        ]))
    }

    func testArrangementSparsePerformance() throws {
        let task = ArrangingTask(itemsInfo: perfomanceArrangementsInfo,
                                 tracks: .init(repeating: .fr(1), count: fixedPerfomanceTracksCount),
                                 flow: .rows,
                                 packing: .sparse)

        self.measure {
            _ = arranger.arrange(task: task)
        }
    }
    
    func testArrangementDensePerformance() throws {
        let task = ArrangingTask(itemsInfo: perfomanceArrangementsInfo,
                                 tracks: .init(repeating: .fr(1), count: fixedPerfomanceTracksCount),
                                 flow: .rows,
                                 packing: .dense)

        self.measure {
            _ = arranger.arrange(task: task)
        }
    }
}
