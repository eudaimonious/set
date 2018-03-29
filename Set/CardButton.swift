//
//  CardView.swift
//  Set
//
//  Created by Margaret Scott on 12/27/17.
//  Copyright © 2017 eudaimonious. All rights reserved.
//

import UIKit

class CardButton: UIButton {
    let pipColors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.6203327134, green: 0.2605122145, blue: 0.7667143085, alpha: 1)]
    let pipSymbols = ["▲", "●", "■"]
    var cardIndex: Int = 0

    var card: Card? {
        didSet {
            cardIndex = card != nil ? card!.hashValue : 0
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        styleCardBorders()
    }

    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        styleCardBorders()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setNeedsLayout()
    }

    func styleCardBorders() {
        clipsToBounds = true
        layer.borderColor = #colorLiteral(red: 0.6203327134, green: 0.2605122145, blue: 0.7667143085, alpha: 1)
        layer.borderWidth = 3.0
        layer.cornerRadius = 8.0
    }

    override func draw(_ rect: CGRect) {
        if let card = card {
            let color = pipColors[card.color]
            color.setFill()
            color.setStroke()

            let title = String(repeating: pipSymbols[card.symbol], count: card.number + 1)
            let titleAttributes = cardColorAndShade(color: color, shading: card.shading)
            setAttributedTitle(NSAttributedString(string: title, attributes: titleAttributes), for: UIControlState.normal)
        }
    }

    func updateOutline() {
        layer.borderColor = getOutlineColor()
    }

    private func getOutlineColor() -> CGColor {
        var color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        if let status = card?.status {
            switch status {
            case .goodMatch: color = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            case .badMatch: color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            case .notSelected: color = #colorLiteral(red: 0.6203327134, green: 0.2605122145, blue: 0.7667143085, alpha: 1)
            case .selected: color = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            default: color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }

        return color.cgColor
    }

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
