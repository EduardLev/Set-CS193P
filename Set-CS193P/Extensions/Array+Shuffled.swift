//
//  Array+Shuffled.swift
//  Set-CS193P
//
//  Created by Eduard Lev on 4/5/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

extension Array {

    /**
     * Shuffles the self array
     */
    mutating func shuffle() {
        guard count > 1 else { return }
        var last = count - 1
        while (last > 0) {
            swapAt(last.arc4random, last)
            last -= 1
        }
    }
}
