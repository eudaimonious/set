//
//  Game.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import Foundation

class Game {
    let cardsToStart = 12
    let deck = Deck()
    lazy var cardsOnTable: [Card] = deck.nextCards(numberOfCards: cardsToStart) ?? []
    private(set) var score = 0
    private(set) var selection: Card?

    func drawCards(numberOfCards: Int) -> [Card]? {
        if let cardsDrawn = deck.nextCards(numberOfCards: numberOfCards) {
            cardsOnTable += cardsDrawn
            return cardsDrawn
        }

        return nil
    }

    func hasSet(_ cards: [Card]) -> Bool {
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

        return isSet
    }

    func updateCardStatuses(after cardButton: CardButton?) {
        updatePriorMatchAttempt()
        updateSelectedCard(cardButton)
        updateCurrentMatchAttempt()
    }

    func updatePriorMatchAttempt() {
        deck.goodMatchCards.forEach { $0.status = .done }
        deck.badMatchCards.forEach { $0.status = .notSelected }
    }

    func updateSelectedCard(_ cardButton: CardButton?) {
        if let card = cardButton?.card {
            switch card.status {
            case .selected:
                card.status = .notSelected
                score -= 1
            case .notSelected: card.status = .selected
            default: print("error")
            }
        }
    }

    func updateCurrentMatchAttempt() {
        let selectedCards = deck.selectedCards
        if selectedCards.count == 3 {
            if hasSet(selectedCards) {
                selectedCards.forEach { $0.status = .goodMatch }
                score += 3
            } else {
                selectedCards.forEach { $0.status = .badMatch }
                score -= 5
            }
        }

    }
}
