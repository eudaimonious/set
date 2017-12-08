//
//  ViewController.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //////////////////////////////
    // Setup

    lazy var game = Game()
    let cardsToStart = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        hideButtons(Array(cardButtons[12...]))
        dealCards(numberOfCards: cardsToStart)
    }

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!

    private func hideButtons(_ buttons: [UIButton]) {
        for button in  buttons {
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }

    @IBAction func touchDealThree(_ sender: UIButton) {
        if game.deck.goodMatchCards.isEmpty {
            dealCards(numberOfCards: 3)
        } else {
            replaceMatchedCards()
            game.updatePriorMatchAttempt()
        }
    }

    @IBAction func touchNewGame(_ sender: UIButton) {
        cardButtons.forEach {
            $0.tag = 0
            $0.setAttributedTitle(nil, for: UIControlState.normal)
        }
        game = Game()
        self.viewDidLoad()
    }

    //////////////////////////////
    // Updating card status

    @IBAction func touchCard(_ sender: UIButton) {
        replaceMatchedCards()
        game.updateCardStatuses(selection: sender.tag)
        updateCardOutlineColors()
    }

    private func replaceMatchedCards() {
        let matchedCards = game.deck.goodMatchCards
        if !matchedCards.isEmpty {
            for button in cardButtons {
                if game.deck.goodMatchCards.map({$0.identifier}).contains(button.tag) {
                    button.setAttributedTitle(nil, for: UIControlState.normal)
                }
            }
            dealCards(numberOfCards: matchedCards.count)
        }
    }

    private func updateCardOutlineColors() {
        for button in cardButtons {
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            button.layer.borderColor = getOutlineColor(for: button)
            button.layer.borderWidth = 3.0
            button.layer.cornerRadius = 8.0
        }
    }

    private func getOutlineColor(for button: UIButton) -> CGColor {
        var color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        if button.tag != 0 {
            let card = game.deck.cards.first(where: { $0.identifier == button.tag })!
            switch card.status {
            case .goodMatch: color = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            case .badMatch: color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            case .notSelected: color = #colorLiteral(red: 0.6203327134, green: 0.2605122145, blue: 0.7667143085, alpha: 1)
            case .selected: color = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            default: color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
        return color.cgColor
    }

    //////////////////////////////
    // Displaying new cards
    private func dealCards(numberOfCards: Int) {
        let cardsToDeal = game.deck.nextCards(numberOfCards: numberOfCards)
        if cardsToDeal == nil { return }
        for card in cardsToDeal! {
            if let button = cardButtons.nextEmptyButton {
                drawCard(button, card)
            }
        }
    }

    private func drawCard(_ button: UIButton, _ card: Card) {
        button.tag = card.identifier
        updateCardOutlineColors()
        setCardDesign(button, card)
    }

    private func setCardDesign(_ button: UIButton, _ card: Card) {
        let title = String(repeating: cardSymbols[card.symbol], count: card.number + 1)
        let titleAttributes = cardColorAndShade(color: cardColors[card.color], shading: card.shading)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: titleAttributes), for: UIControlState.normal)
    }

    let cardColors = [#colorLiteral(red: 0.6203327134, green: 0.2605122145, blue: 0.7667143085, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)]
    let cardSymbols = ["▲", "●", "■"]

    private func cardColorAndShade(color: UIColor, shading: Int) -> [NSAttributedStringKey:Any] {
        switch shading {
        case 0:
            return [.strokeColor: color, .strokeWidth: 5] // outlined
        case 1:
            return [.foregroundColor: color.withAlphaComponent(0.15)] // shaded
        case 2:
            return [.foregroundColor: color] // filled in
        default:
            return [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        }
    }
}

extension Array where Element: UIButton {
    var nextEmptyButton: UIButton? {
        return filter { $0.attributedTitle(for: UIControlState.normal) == nil }.first
    }
}
