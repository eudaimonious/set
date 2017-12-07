//
//  ViewController.swift
//  Set
//
//  Created by Margaret Scott on 12/6/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var game = Game()
    let cardsToStart = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        hideButtons(Array(cardButtons[12...]))
        dealCards(numberOfCards: cardsToStart)
    }

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!

    @IBAction func touchDealThree(_ sender: UIButton) {
    }

    @IBAction func touchCard(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let selectedCardButtons = cardButtons.selected
        if selectedCardButtons.count == 3 {
            updateMatchIndicatorsFor(selectedCardButtons)
        } else {
            let color = sender.isSelected ? #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) : #colorLiteral(red: 0.6203327134, green: 0.2605122145, blue: 0.7667143085, alpha: 1)
            setCardOutline(sender,  color)
        }
    }

    @IBAction func touchNewGame(_ sender: UIButton) {
    }

    private func hideButtons(_ buttons: [UIButton]) {
        for button in  buttons {
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }

    private func dealCards(numberOfCards: Int) {
        let cardsToDeal = game.deck.nextCards(numberOfCards: numberOfCards)
        for card in cardsToDeal {
            if let button = cardButtons.nextEmptyButton {
                drawCard(button, card)
            }
        }
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

    private func drawCard(_ button: UIButton, _ card: Card) {
        setCardOutline(button)
        setCardDesign(button, card)
    }

    private func setCardDesign(_ button: UIButton, _ card: Card) {
        let title = String(repeating: cardSymbols[card.symbol], count: card.number + 1)
        let titleAttributes = cardColorAndShade(color: cardColors[card.color], shading: card.shading)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: titleAttributes), for: UIControlState.normal)
    }

    private func setCardOutline(_ button: UIButton, _ color: UIColor = #colorLiteral(red: 0.6203327134, green: 0.2605122145, blue: 0.7667143085, alpha: 1)) {
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 3.0
        button.layer.cornerRadius = 8.0
    }

    private func updateMatchIndicatorsFor(_ buttons: [UIButton]) {
        let selectedCardIndices = buttons.map { cardButtons.index(of: $0)! }
        if game.hasSet(selectedCardIndices) {
            buttons.forEach { setCardOutline($0, #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)) }
        } else {
            buttons.forEach { setCardOutline($0, #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)) }
        }
    }
}

extension Array where Element: UIButton {
    var nextEmptyButton: UIButton? {
        return filter { $0.attributedTitle(for: UIControlState.normal) == nil }.first
    }

    var selected: [UIButton] {
        return filter { $0.isSelected }
    }
}
