//
//  Int+Random.swift
//  Set-CS193P
//
//  Created by Eduard Lev on 4/5/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

extension Int {
/**
 * Returns a random integer from 0 to the value of `self`
 */
    var arc4random: Int {
        guard self != 0 else { return 0 }
        return Int(arc4random_uniform(UInt32(abs(self))))
    }
}
