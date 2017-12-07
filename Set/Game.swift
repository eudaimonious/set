//
//  Game.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import Foundation

class Game {
    let deck = Deck()

    func hasSet(_ cardIndices: [Int]) -> Bool {
        let cards = cardIndices.map { deck.cards[$0] }
        var isSet = true

        let colorSet = Set(cards.map { $0.color })
        let numberSet = Set(cards.map { $0.number })
        let shadingSet = Set(cards.map { $0.shading })
        let symbolSet = Set(cards.map { $0.symbol })

        for set in [colorSet, numberSet, shadingSet, symbolSet] {
            if set.count == 2 {
                isSet = false
                break
            }
        }
        cards.forEach { $0.status = .matched }
        return isSet
    }
}
