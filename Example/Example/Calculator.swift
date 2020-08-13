//
//  Calculator.swift
//  Grid_Example
//
//  Created by Denis Obukhov on 20.05.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import ExyteGrid

struct Calculator: View {
    enum Mode: CustomStringConvertible {
        case system
        case second
        
        var description: String {
            switch self {
            case .system:
                return "System"
            case .second:
                return "Alternative"
            }
        }
    }
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @State var mode: Mode = .system

    var isPortrait: Bool {
        let result = verticalSizeClass == .regular && horizontalSizeClass == .compact
        return result
    }
    
    var digits: [MathOperation] {
        (1..<10).map { .digit($0) } + [.digit(0)]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .trailing, spacing: 0) {
                    self.modesPicker
                    Spacer()
                    Text("565 626")
                        .foregroundColor(.white)
                        .font(.custom("PingFang TC", size: 90))
                        .fontWeight(.light)
                        .minimumScaleFactor(0.01)
                    
                    Grid(tracks: self.tracks, spacing: 10) {
                        self.mainArithmeticButtons
                        self.topButtons
                        self.clearButton

                        GridGroup {
                            GridGroup(self.digits, id: \.self) {
                                //Only homogeneous "if" clauses are supported
                                if self.mode == .system && $0 == .digit(0) {
                                      CalcButton($0)
                                          .gridSpan(column: 2)
                                  } else {
                                      CalcButton($0)
                                  }
                            }
                        }
                        
                        GridGroup([MathOperation.point], id: \.self) {
                            CalcButton($0)
                        }
                        
                        self.landscapeButtons
                    }
                    .gridContentMode(.fill)
                    .gridAnimation(.easeInOut)
                    .frame(width: self.proportionalSize(geometry: geometry).width,
                           height: self.proportionalSize(geometry: geometry).height)
                }
            }
        }
        .environment(\.colorScheme, .dark)
    }
    
    var tracks: [GridTrack] {
        self.isPortrait ? (self.mode == .system ? 4 : 5) : (self.mode == .system ? 10 : 11)
    }
    
    var landscapeButtons: GridGroup {
        let funcCount = (self.mode == .system ? 30 : 24)
        let functions: [MathOperation] = self.isPortrait ? [] : (0..<funcCount).map { .function($0) }
        return GridGroup(functions, id: \.self) {
            CalcButton($0)
                .gridStart(column: (functions.firstIndex(of: $0)!)  % 6)
                .animation(nil)
        }
    }
    
    var mainArithmeticButtons: GridGroup {
        switch self.mode {
        case .system:
            let operations: [MathOperation] = [.divide, .multiply, .substract, .add, .equal]
            return GridGroup(0..<operations.count) {
                CalcButton(operations[$0])
                    .gridStart(column: self.tracks.count - 1)
            }
        case .second:
            return GridGroup {
                CalcButton(.clear)
                    .gridStart(column: self.tracks.count - 1)
                    .gridID(MathOperation.clear)
                
                CalcButton(.divide)
                    .gridStart(column: self.tracks.count - 1)
                
                CalcButton(.multiply)
                    .gridStart(column: self.tracks.count - 1)
                
                CalcButton(.substract)
                    .gridStart(column: self.tracks.count - 2)
                
                CalcButton(.add)
                    .gridStart(column: self.tracks.count - 2)
                    .gridSpan(row: 2)
                
                CalcButton(.equal)
                    .gridStart(column: self.tracks.count - 3)
                    .gridSpan(column: 3)
            }
        }
    }

    func proportionalSize(geometry: GeometryProxy) -> CGSize {
        let height: CGFloat
        if self.isPortrait {
            height = geometry.size.width * 5 / 4
        } else {
            height = geometry.size.width * 4 / 10
        }
        return CGSize(width: geometry.size.width,
                      height: height)
    }

    var topButtons: GridGroup {
        switch self.mode {
        case .system:
            return GridGroup {
                CalcButton(.percent)
                    .animation(nil)
                CalcButton(.sign)
                    .animation(nil)
            }
        case .second:
            return GridGroup.empty
        }
    }

    var clearButton: GridGroup {
        if self.mode == .system {
            return GridGroup {
                CalcButton(.clear)
                    .gridID(MathOperation.clear)
            }
        } else {
            return GridGroup.empty
        }
    }
    
    private var modesPicker: some View {
        Picker("Mode", selection: $mode) {
            ForEach([Mode.system, Mode.second], id: \.self) {
                Text($0.description)
                    .tag($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        Calculator()
            .environment(\.verticalSizeClass, .regular)
            .environment(\.horizontalSizeClass, .compact)
    }
}
