//
//  Card.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import Foundation

class Card {
    private static var identifierFactory = 0

    let identifier: Int
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
        self.identifier = Card.getUniqueIdentifier()
    }

    enum Status {
        case badMatch
        case done
        case goodMatch
        case inDeck
        case notSelected
        case selected
    }

    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
