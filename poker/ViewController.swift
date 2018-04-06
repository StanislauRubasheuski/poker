//
//  ViewController.swift
//  poker
//
//  Created by artur on 05.04.2018.
//  Copyright © 2018 artur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    
    @IBOutlet var handCardPlayerOne: [PlayingCardView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let card = deck.draw()
    }
}

