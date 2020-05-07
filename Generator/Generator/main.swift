//
//  main.swift
//  Generator
//
//  Created by Denis Obukhov on 07.05.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

let paramsCount = 10

let fileTemplate =
"""
// GENERATED

// swiftlint:disable large_tuple line_length file_length

import SwiftUI

extension Grid {
%@
}
"""

let constructorTemplate =
"""
    public init<%@T: View>(tracks: [TrackSize], spacing: CGFloat = Constants.defaultSpacing, @ViewBuilder content: () -> Content) where Content == TupleView<(%@)> {
        self.trackSizes = tracks
        self.tracksCount = self.trackSizes.count
        self.spacing = spacing
        self.items =
            %@
    }
"""

enum TupleType: Int, CustomStringConvertible, Comparable {
    case view = 0
    case forEach = 1
    
    var tupleDeclaraion: String {
        switch self {
        case .view:
            return "C"
        case .forEach:
            return "ForEach<Range<Int>, Int, T>"
        }
    }
    
    static func < (lhs: TupleType, rhs: TupleType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    var description: String {
        switch self {
        case .view:
            return "v"
        case .forEach:
            return "f"
        }
    }
}

func permute<T>(list: [T], minLen: Int = 2) -> Set<[T]> {
    func permute(fromList: [T], toList: [T], minLen: Int, set: inout Set<[T]>) {
        if toList.count >= minLen {
            set.insert(toList)
        }
        if !fromList.isEmpty {
            for (index, item) in fromList.enumerated() {
                var newFrom = fromList
                newFrom.remove(at: index)
                permute(fromList: newFrom, toList: toList + [item], minLen: minLen, set: &set)
            }
        }
    }

    var set = Set<[T]>()
    permute(fromList: list, toList:[], minLen: minLen, set: &set)
    return set
}

var resultSet: Set<[TupleType]> = Set()

let queue = DispatchQueue.global()
let lock = NSLock()

DispatchQueue.concurrentPerform(iterations: paramsCount) { i in
    let array = Array<TupleType>(repeating: .view, count: i) + [.forEach]
    let result = permute(list: array, minLen: array.count)
    lock.lock()
    resultSet = resultSet.union(result)
    lock.unlock()
}

var sortedArray = Array(resultSet).sorted { (lhs, rhs) -> Bool in
    if lhs.count == rhs.count {
        return lhs.firstIndex(of: .forEach)! < rhs.firstIndex(of: .forEach)!
    }
    return lhs.count < rhs.count
}

//for element in sortedArray {
//    print(element)
//}

var consturctors: [String] = []

for types in sortedArray {
    let viewsCount = types.reduce(0) { $0 + ($1 == .view ? 1 : 0)}
    let viewGenericsDeclaration = (0..<viewsCount).reduce("") { $0 + "C\($1): View, " }

    var viewNumber = 0
    let tupleDeclaration: String = types.map { type in
        switch type {
        case .view:
            let result = "C\(viewNumber)"
            viewNumber += 1
            return result
        case .forEach:
            return "ForEach<Range<Int>, Int, T>"
        }
    }.joined(separator: ", ")
    
    viewNumber = 0
    
    var lastType: TupleType?
    
    let itemsConstructor = types.reduce("") { result, element in
        let prefix: String
        let tabs = "            "
        
        switch lastType {
        case .forEach:
            switch element {
            case .view:
                prefix = "\n\(tabs)+ ["
            case .forEach:
                prefix = "\n\(tabs)+ "
            }
        case .view:
            switch element {
            case .view:
                prefix = ",\n\(tabs)"
            case .forEach:
                prefix = "]\n\(tabs)+ "
            }
        case .none:
            switch element {
            case .view:
                prefix = "["
            case .forEach:
                prefix = ""
            }
        }
        
        let tupleAccessor: String = types.count > 1 ? ".\(viewNumber)" : ""

        let constructionItem: String
        switch element {
        case .view:
            constructionItem = "GridItem(AnyView(content().value\(tupleAccessor)), id: AnyHashable(\(viewNumber)))"
        case .forEach:
            constructionItem = "content().value\(tupleAccessor).data.map { GridItem(AnyView(content().value\(tupleAccessor).content($0)), id: AnyHashable(($0 + 10))) }"
        }
        
        var postfix = ""
        if viewNumber == types.count - 1 {
            switch element {
            case .view:
                postfix = "]"
            case .forEach:
                ()
            }
        }

        lastType = element
        viewNumber += 1
        return result + prefix + constructionItem + postfix

    }
    
    consturctors.append(String(format: constructorTemplate, viewGenericsDeclaration, tupleDeclaration, itemsConstructor))
}

let file = String(format: fileTemplate, consturctors.joined(separator: "\n\n"))
print(file)
