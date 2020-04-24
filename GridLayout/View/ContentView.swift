//
//  ContentView.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    enum Mode: CaseIterable {
        case first, second
    }
    
    @State var mode: Mode = .first
    
    var body: some View {
        Grid(columns: 3, spacing: 0) {
            
            Text("Lorem ipsum dolor sit amet, consectetuer adipiscing elit.")
                .background(Color.gray)
                .foregroundColor(Color.red)
            //.gridSpan(column: 1, row: 2)
            
            Text("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.")
                .background(Color.pink)
                .foregroundColor(Color.blue)
                .gridSpan(column: 1, row: 1)
            
            Text("Lorem ipsum dolor sit amet. ")
                .background(Color.green)
                .foregroundColor(Color.yellow)
                .gridSpan(column: 2, row: 1)
                
            Text("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur.")
                .background(Color.red)
                .foregroundColor(Color.blue)
                .gridSpan(column: 1, row: 2)
            
            Text("Lorem ipsum dolor sit.")
                .background(Color.gray)
                .foregroundColor(Color.red)
            Text("Lorem ipsum dolor sit.")
                .background(Color.gray)
                .foregroundColor(Color.red)
        }
        .gridContentMode(.scroll(alignment: .top))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
