//
//  TrackSize.swift
//  GridLayout
//
//  Created by Denis Obukhov on 22.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

/// Size of the each track.
/// fr(N) sizes a track proportionally to the bounding rect with the respect of specified fraction N as a part of total fractions count.
/// const(N) sizes a track to be equal to the specified size N.
public enum TrackSize {
    case fr(Int)
    case const(Int)
    
    // TODO: Add .min(Int)
}
