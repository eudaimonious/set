//
//  Game.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import Foundation

class Game {
    let numberOfCardsToStart = 12
    let deck = Deck()
    lazy var cardsToStart: [Card] = deck.nextCards(numberOfCards: numberOfCardsToStart) ?? []
    private(set) var score = 0

    func drawCards(numberOfCards: Int) -> [Card]? {
        if let cardsDrawn = deck.nextCards(numberOfCards: numberOfCards) {
            cardsToStart += cardsDrawn
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

    private func clear(badMatch: [Card]) {
        badMatch.forEach { $0.status = .notSelected }
    }

    private func clear(goodMatch: [Card]) {
        goodMatch.forEach { $0.status = .done }
    }

    private func deselect(_ tappedCard: Card) {
        tappedCard.status = .notSelected
    }

    private func select(_ tappedCard: Card) {
        tappedCard.status = .selected
    }

    private func mark(badMatch: [Card]) {
        badMatch.forEach { $0.status = .badMatch }
    }

    private func mark(goodMatch: [Card]) {
        goodMatch.forEach { $0.status = .goodMatch }
    }


    private func penalizeBadMatch() {
        score -= 5
    }

    private func penalizeDeselection() {
        score -= 1
    }

    private func rewardGoodMatch() {
        score += 3
    }

    func updateDeckAndScore(_ tappedCard: Card) {

        if tappedCard.status == .selected {
            deselect(tappedCard)
            penalizeDeselection()
            return
        }

        if deck.selectedCards.count == 2 {
            let cardsForPotentialMatch = deck.selectedCards + [tappedCard]
            let isGoodMatch = hasSet(cardsForPotentialMatch)

            if !isGoodMatch {
                mark(badMatch: cardsForPotentialMatch)
                penalizeBadMatch()
            } else {
                mark(goodMatch: cardsForPotentialMatch)
                rewardGoodMatch()
            }
            return
        }

        if !deck.badMatchCards.isEmpty {
            clear(badMatch: deck.badMatchCards)
            select(tappedCard)
            return
        }


        if !deck.goodMatchCards.isEmpty {
            let didTapAGoodMatch = deck.goodMatchCards.contains(tappedCard)
            if deck.cardsOnTable.count > numberOfCardsToStart {
                clear(goodMatch: deck.goodMatchCards)
                if !didTapAGoodMatch {
                    select(tappedCard)
                }
                return
            // Are there 12 or fewer cards on the table?
            } else {
                // Are there more cards in the deck?
                if !deck.cardsInDeck.isEmpty {
                    print("Player made first selection since a good match and gets new cards in their place.")
                    // Replace the good match cards with new cards and turn one card to .selected unless it was a matched card
                    deck.goodMatchCards.forEach { $0.status = .done }

                    if !didTapAGoodMatch {
                        print("Player's selection was not a matched card so it is now selected.")
                        tappedCard.status = .selected
                    }

                    _ = deck.nextCards(numberOfCards: 3)
                    return
                }
            }
        }

        // Otherwise simply select the tapped card
        print("Player has made a new selection.")
        tappedCard.status = .selected
    }
}
