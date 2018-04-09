//
//  ViewController.swift
//  poker
//
//  Created by artur on 05.04.2018.
//  Copyright © 2018 artur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var labelHand: UILabel!
    @IBOutlet weak var labelBoard: UILabel!
    @IBOutlet weak var labelCombination: UILabel!
    var analyse = CombinationAnalysis()
    var deck = PlayingCardDeck()
    
    @IBOutlet var handCardPlayerOne: [PlayingCardView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let card = deck.draw()
    }
    
    @IBOutlet weak var buttonRunTest: UIButton!
    @IBAction func buttonRunTestAction(_ sender: Any) {
        var deck = PlayingCardDeck()
        var hand = [PlayingCard]()
        var board = [PlayingCard]()
        var count = 0
        var index: Int
        var card: PlayingCard
        while count < 2 {
            index = Int(arc4random_uniform(51))
            card = deck.cards[index]
            if !card.isFaceUp {
                hand.append(card)
                deck.cards[index].isFaceUp = true
                count += 1
            }
        }
        while count < 7 {
            index = Int(arc4random_uniform(51))
            card = deck.cards[index]
            if !card.isFaceUp {
                board.append(card)
                deck.cards[index].isFaceUp = true
                count += 1
            }
        }
        
        var result = analyse.computeCombination(playingHand: hand, playingBoard: board)
        labelHand.text = "\(hand[0]) \(hand[1])"
        labelBoard.text = "\(board[0]) \(board[1]) \(board[2]) \(board[3]) \(board[4])"
        labelCombination.text = "\(result)"
    }
    
}

