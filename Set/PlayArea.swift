//
//  PlayArea.swift
//  Set
//
//  Created by Margaret Scott on 3/28/18.
//  Copyright © 2018 eudaimonious. All rights reserved.
//

import UIKit

class PlayArea: UIView {

    weak var delegate: UIViewController?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviews()
    }

    func updateSubviews() {
        guard let cardButtons = subviews as? [CardButton] else { return }

        if cardButtons.count > 0 {
            let grid = AspectRatioGrid(for: bounds, withNoOfFrames: cardButtons.count)
            for index in cardButtons.indices {
                let insetXY = (grid[index]?.height ?? 400)/100
                let button = cardButtons[index]
                button.frame = grid[index]?.insetBy(dx: insetXY, dy: insetXY) ?? CGRect.zero
                button.updateOutline()
            }
        }
    }
}
