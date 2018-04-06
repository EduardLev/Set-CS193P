//
//  Card.swift
//  Set-CS193P
//
//  Created by Eduard Lev on 4/5/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

/**
 * Structure that represents one card in the Set game
 *
 * There are four attribute of a card: number, symbol, shading, and color
 * These are of type Int and are either 0, 1 or 2, since there are
 * only three possibilities for each property.
 */
struct Card: Equatable {
    let number: Int
    let symbol: Int
    let shading: Int
    let color: Int

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number
            && lhs.symbol == rhs.symbol
            && lhs.shading == rhs.shading
            && lhs.color == rhs.color
    }
}

extension Card: Hashable {
    var hashValue: Int {
        let digits = [number, symbol, shading, color]
        return Int(digits.map(String.init).joined())!
    }
}

