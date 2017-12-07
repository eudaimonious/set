//
//  Card.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import Foundation

class Card {
    let color: Int
    let number: Int
    let shading: Int
    let symbol: Int

    var status: Status = .inDeck

    init(number: Int, symbol: Int, shading: Int, color: Int) {
        self.color = color
        self.number = number
        self.shading = shading
        self.symbol = symbol
    }

    enum Status {
        case inDeck
        case inPlay
        case matched
    }
}
