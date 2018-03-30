//
//  ViewController.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Setup

    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var playArea: PlayArea! {
        didSet {
            playArea.delegate = self
        }
    }

    var cardButtons: [CardButton] = [] {
        didSet {
            playArea.updateSubviews()
        }
    }

    private var game: Game! {
        didSet {
            scoreLabel.text = "Score: \(game.score)"
            playArea.subviews.forEach { $0.removeFromSuperview() }
            cardButtons = []
            game.cardsToStart.forEach { addCardButton(for: $0) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game()
    }

    // MARK: - Gestures

    @IBAction func touchNewGame(_ sender: UIButton) {
        game = Game()
        self.viewDidLoad()
    }

    @IBAction func touchDealThree(_ sender: UIButton) {
        // If there's a good match on the table, replace those cards
        let matchedButtons = detectGoodMatchOnTable()
        if !matchedButtons.isEmpty {
            if let cardsToDeal = game.drawCards(numberOfCards: 3) {
                replaceGoodMatchOnTable(goodMatchButtons: matchedButtons, newCards: cardsToDeal)
            }
        } else {
            // Otherwise, add new cards
            dealThreeCards()
        }
    }

    @objc func touchCard(_ recognizer: UITapGestureRecognizer) {
        guard let tappedButton = recognizer.view as? CardButton else { return }
        guard let tappedCard = tappedButton.card else { return }

        let matchedButtons = detectGoodMatchOnTable()
        game.updateDeckAndScore(tappedCard)
        let cardsToDeal = getNextCards()

        if matchedButtons.count == cardsToDeal.count {
            replaceGoodMatchOnTable(goodMatchButtons: matchedButtons, newCards: cardsToDeal)
        } else {
            remove(matchedButtons)
        }

        playArea.updateSubviews()
        scoreLabel.text = "Score: \(game.score)"
    }

    /// MARK: - Add cards

    private func addCardButton(for card: Card) {
        let newCardButton = CardButton()
        newCardButton.card = card
        newCardButton.contentMode = .redraw
        newCardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard)))
        playArea.addSubview(newCardButton)
        cardButtons.append(newCardButton)
    }

    private func dealThreeCards() {
        if let cardsToDeal = game.drawCards(numberOfCards: 3) {
            for index in cardsToDeal.indices {
                addCardButton(for: cardsToDeal[index])
            }
        }
    }

    private func getNextCards() -> [Card] {
        let visibleCards: [Card] = cardButtons.flatMap { $0.card }
        return game.deck.notSelectedCards.filter { (cardFromModel) in
            !visibleCards.contains(cardFromModel)
        }
    }

    private func replaceGoodMatchOnTable(goodMatchButtons matchedButtons: [CardButton], newCards cardsToDeal: [Card]) {
        for (index, button) in matchedButtons.enumerated() {
            button.card = cardsToDeal[index]
        }
    }

    /// MARK: - Misc

    private func detectGoodMatchOnTable() -> [CardButton] {
        let matchedCards = game.deck.goodMatchCards
        var matchedButtons: [CardButton] = []
        if !matchedCards.isEmpty {
            for button in cardButtons {
                if let card = button.card, game.deck.goodMatchCards.contains(card) {
                    matchedButtons.append(button)
                }
            }
        }
        return matchedButtons
    }

    private func remove(_ matchedButtons: [CardButton]) {
        matchedButtons.forEach { (matchedButton) in
            if let index = cardButtons.index(of: matchedButton) {
                cardButtons[index].removeFromSuperview()
                cardButtons.remove(at: index)
            }
        }

    }

}
