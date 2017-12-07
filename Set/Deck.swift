//
//  Deck.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import Foundation

class Deck {
    var cards = [Card]()
    init(){
        buildCards()
        cards.shuffle()
    }

    var cardsInDeck: [Card] {
        return cards.filter { $0.status == Card.Status.inDeck }
    }

    func buildCards() {
        for numberValue in 0...2 {
            for symbolValue in 0...2{
                for shadingValue in 0...2 {
                    for colorValue in 0...2 {
                        cards.append(Card(number: numberValue, symbol: symbolValue, shading: shadingValue, color: colorValue))
                    }

                }

            }

        }
    }

    func nextCards(numberOfCards: Int) -> [Card] {
        let cardsToDeal = cardsInDeck[0..<numberOfCards]
        cardsToDeal.forEach { $0.status = Card.Status.inPlay }
        return Array(cardsToDeal)
    }

}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
