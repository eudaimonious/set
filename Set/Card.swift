//
//  Card.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import Foundation

class Card: Hashable {

    // MARK: - Hashable

    private static var identifierFactory = 0

    let hashValue: Int = {
        identifierFactory += 1
        return identifierFactory
    }()

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    var status = Status.inDeck

    // MARK: - Visible attributes

    let color: Int
    let number: Int
    let shading: Int
    let symbol: Int

    init(number: Int, symbol: Int, shading: Int, color: Int) {
        self.color = color
        self.number = number
        self.shading = shading
        self.status = .inDeck
        self.symbol = symbol
    }

    enum Status {
        case badMatch
        case done
        case goodMatch
        case inDeck
        case notSelected
        case selected
    }

}
