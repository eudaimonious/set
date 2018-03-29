//
//  PlayArea.swift
//  Set
//
//  Created by Margaret Scott on 3/28/18.
//  Copyright © 2018 eudaimonious. All rights reserved.
//

import UIKit

protocol LayoutViews: class {
    func updateViewFromModel()
}

class PlayArea: UIView {

    weak var delegate: LayoutViews?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        delegate?.updateViewFromModel()
    }

    func updateOutlinesFromModel() {
        guard let cardButtons = subviews as? [CardButton] else { return }
        cardButtons.forEach { $0.updateOutline() }
    }

}
