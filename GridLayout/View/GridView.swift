//
//  GridView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 17.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct Grid: View {
    let items: [GridArrangeable]
    let columnsCount: Int
    private let arranger = LayoutArrangerImpl() as LayoutArranger
    
    private lazy var arrangement: LayoutArrangement = {
        let filteredItems = self.items.filter { $0 as? EmptyGridItem != nil }
        let arrangement = self.arranger.arrange(items: self.items,
                                                columnsCount: self.columnsCount)
        print(arrangement)
        return arrangement
    }()
    
    var body: some View {
        return Rectangle()
    }

}

struct GridView_Previews: PreviewProvider {

    static var previews: some View {
        let someCondition = false

        return Grid(columnsCount: 4) {

        }
    }
}
