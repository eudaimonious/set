//
//  ViewController.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LayoutViews {

    // MARK: - Setup

    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var playArea: PlayArea! {
        didSet {
            playArea.delegate = self
        }
    }

    var cardButtons: [CardButton] = []

    private var game: Game! {
        didSet {
            scoreLabel.text = "Score: \(game.score)"
            playArea.subviews.forEach { $0.removeFromSuperview() }
            cardButtons = []
            let cardsOnTable = game.cardsOnTable
            cardsOnTable.indices.forEach { addSetCardView(for: cardsOnTable[$0]) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game()
    }

    func updateViewFromModel() {
        let grid = AspectRatioGrid(for: playArea.bounds, withNoOfFrames: game.cardsOnTable.count)
        for index in cardButtons.indices {
            let insetXY = (grid[index]?.height ?? 400)/100
            cardButtons[index].frame = grid[index]?.insetBy(dx: insetXY, dy: insetXY) ?? CGRect.zero
        }
    }

    // MARK: - Gestures

    @IBAction func touchDealThree(_ sender: UIButton) {
        if game.deck.goodMatchCards.isEmpty {
            dealCards(numberOfCards: 3)
        } else {
            _ = replaceMatchedCards()
            game.updatePriorMatchAttempt()
        }
    }

    @IBAction func touchNewGame(_ sender: UIButton) {
        game = Game()
        self.viewDidLoad()
    }

    @objc func touchCard(_ recognizer: UITapGestureRecognizer) {
        guard let tappedCard = recognizer.view as? CardButton else { return }

        let unselectableCards = replaceMatchedCards()
        let cardSelection = unselectableCards.contains(tappedCard) ? nil : tappedCard
        game.updateCardStatuses(after: cardSelection)
        updateViewFromModel()
        playArea.updateOutlinesFromModel()
        scoreLabel.text = "Score: \(game.score)"
    }

    // MARK: - Update cards

    private func replaceMatchedCards() -> [UIButton] {
        print("replacing cards")
        let matchedCards = game.deck.goodMatchCards
        var matchedButtons: [CardButton] = []
        if !matchedCards.isEmpty {
            for button in cardButtons {
                if let card = button.card, game.deck.goodMatchCards.contains(card) {
                    button.removeFromSuperview()
                    matchedButtons.append(button)
                }
            }

            // TODO: If there are already 12 or more cards on the table don't draw three more cards
            dealCards(numberOfCards: matchedCards.count)
        }

        return matchedButtons
    }

    /// MARK: - Add cards
    private func dealCards(numberOfCards: Int) {
        if let cardsToDeal = game.drawCards(numberOfCards: numberOfCards) {
            for index in cardsToDeal.indices {
                addSetCardView(for: cardsToDeal[index])
            }
        }
    }

    private func addSetCardView(for card: Card){
        let newCardButton = CardButton()
        newCardButton.card = card
        newCardButton.contentMode = .redraw
        var addCardToEnd = true

        substituteMatchedCard: for (index, existingCardButton) in cardButtons.enumerated() {
            let status = existingCardButton.card?.status
            if status == .goodMatch {
                cardButtons[index] = newCardButton
                addCardToEnd = false
                break substituteMatchedCard
            }
        }

        if addCardToEnd {
            cardButtons.append(newCardButton)
        }

        newCardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard)))
        playArea.addSubview(newCardButton)
        game.cardsOnTable = cardButtons.map { $0.card! }
        updateViewFromModel()
    }

}
