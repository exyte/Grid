//
//  ArrangingWithStartsTest.swift
//  GridTests
//
//  Created by Denis Obukhov on 06.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import XCTest
import SwiftUI
@testable import Grid

class ArrangingWithStartsTest: XCTestCase {
    
    private struct MockArranger: LayoutArranging {}
    private let arranger = MockArranger()
    
    func gridItem(index: Int) -> GridItem {
        GridItem(AnyView(EmptyView()), id: AnyHashable(index))
    }

private lazy var spanPreferences =
    (0..<6).map { SpanPreference(item: self.gridItem(index: $0), span: [1, 1]) }
        + [SpanPreference(item: gridItem(index: 6), span: [3, 1]),
           SpanPreference(item: gridItem(index: 7), span: [2, 1]),
           SpanPreference(item: gridItem(index: 8), span: [2, 2]),
           SpanPreference(item: gridItem(index: 9), span: [1, 1]),
           SpanPreference(item: gridItem(index: 10), span: [1, 10]),
           SpanPreference(item: gridItem(index: 11), span: [2, 3]),
           SpanPreference(item: gridItem(index: 12), span: [1, 3]),
           SpanPreference(item: gridItem(index: 13), span: [1, 1]),
           SpanPreference(item: gridItem(index: 14), span: [1, 1])
    ]
    
    private lazy var startPreferences =
        (0..<6).map { StartPreference(item: self.gridItem(index: $0), start: nil) }
            + [StartPreference(item: gridItem(index: 6), start: nil),
               StartPreference(item: gridItem(index: 7), start: nil),
               StartPreference(item: gridItem(index: 8), start: [5, 1]),
               StartPreference(item: gridItem(index: 9), start: [nil, 2]),
               StartPreference(item: gridItem(index: 10), start: [3, 0]),
               StartPreference(item: gridItem(index: 11), start: nil),
               StartPreference(item: gridItem(index: 12), start: nil),
               StartPreference(item: gridItem(index: 13), start: [2, nil]),
               StartPreference(item: gridItem(index: 14), start: nil)
        ]

    func testArrangementDenseRows() throws {
        let arrangement = arranger.arrange(spanPreferences: spanPreferences,
                                           startPreferences: startPreferences,
                                           fixedTracksCount: 4,
                                           flow: .rows,
                                           packing: .dense)

        XCTAssertEqual(arrangement, LayoutArrangement(columnsCount: 4, rowsCount: 10, items: [
            ArrangedItem(gridItem: gridItem(index: 10), startIndex: [3, 0], endIndex: [3, 9]),
            ArrangedItem(gridItem: gridItem(index: 13), startIndex: [2, 0], endIndex: [2, 0]),
            ArrangedItem(gridItem: gridItem(index: 8), startIndex: [0, 1], endIndex: [1, 2]),
            ArrangedItem(gridItem: gridItem(index: 9), startIndex: [2, 2], endIndex: [2, 2]),
            ArrangedItem(gridItem: gridItem(index: 0), startIndex: [0, 0], endIndex: [0, 0]),
            ArrangedItem(gridItem: gridItem(index: 1), startIndex: [1, 0], endIndex: [1, 0]),
            ArrangedItem(gridItem: gridItem(index: 2), startIndex: [2, 1], endIndex: [2, 1]),
            ArrangedItem(gridItem: gridItem(index: 3), startIndex: [0, 3], endIndex: [0, 3]),
            ArrangedItem(gridItem: gridItem(index: 4), startIndex: [1, 3], endIndex: [1, 3]),
            ArrangedItem(gridItem: gridItem(index: 5), startIndex: [2, 3], endIndex: [2, 3]),
            ArrangedItem(gridItem: gridItem(index: 6), startIndex: [0, 4], endIndex: [2, 4]),
            ArrangedItem(gridItem: gridItem(index: 7), startIndex: [0, 5], endIndex: [1, 5]),
            ArrangedItem(gridItem: gridItem(index: 11), startIndex: [0, 6], endIndex: [1, 8]),
            ArrangedItem(gridItem: gridItem(index: 12), startIndex: [2, 5], endIndex: [2, 7]),
            ArrangedItem(gridItem: gridItem(index: 14), startIndex: [2, 8], endIndex: [2, 8])
        ]))
    }
    
}
