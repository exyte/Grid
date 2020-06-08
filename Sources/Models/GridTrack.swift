//
//  GridTrack.swift
//  ExyteGrid
//
//  Created by Denis Obukhov on 22.04.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import CoreGraphics

// swiftlint:disable identifier_name

/// Size of the each track.
/// fr(N) sizes a track proportionally to the bounding rect with the respect of specified fraction N as a part of total fractions count.
/// const(N) sizes a track to be equal to the specified size N.
public enum GridTrack {
    case fr(CGFloat)
    case pt(CGFloat)
    case fit
    
    var isIntrinsic: Bool {
        switch self {
        case .fr:
            return false
        case .pt:
            return false
        case .fit:
            return true
        }
    }
    
    var isFlexible: Bool {
        switch self {
        case .fr:
            return true
        case .pt:
            return false
        case .fit:
            return false
        }
    }
}

extension Array: ExpressibleByIntegerLiteral where Element == GridTrack {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral value: Self.IntegerLiteralType) {
        self = .init(repeating: .fr(Constants.defaultFractionSize), count: value)
    }
}

extension GridTrack: Equatable, Hashable { }
