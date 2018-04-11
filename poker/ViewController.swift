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
    var analyseDraws = DrawsAnalysis()
    var deck = PlayingCardDeck()
    
    @IBOutlet weak var labelPara0: UILabel!
    @IBOutlet weak var labelPara1: UILabel!
    @IBOutlet weak var labelTwoPairs0: UILabel!
    @IBOutlet weak var labelTwoPairs1: UILabel!
    @IBOutlet weak var labelTrips0: UILabel!
    @IBOutlet weak var labelTrips1: UILabel!
    @IBOutlet weak var labelStraight0: UILabel!
    @IBOutlet weak var labelStraight1: UILabel!
    @IBOutlet weak var labelFlush0: UILabel!
    @IBOutlet weak var labelFlush1: UILabel!
    @IBOutlet weak var labelFull0: UILabel!
    @IBOutlet weak var labelFull1: UILabel!
    @IBOutlet weak var labelKare0: UILabel!
    @IBOutlet weak var labelKare1: UILabel!
    @IBOutlet weak var labelStrFlush0: UILabel!
    @IBOutlet weak var labelStrFlush1: UILabel!
    @IBOutlet weak var labelRoyal0: UILabel!
    @IBOutlet weak var labelRoyal1: UILabel!
    @IBOutlet weak var labelSum0: UILabel!
    @IBOutlet weak var labelSum1: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        while count < 6 {
            index = Int(arc4random_uniform(51))
            card = deck.cards[index]
            if !card.isFaceUp {
                board.append(card)
                deck.cards[index].isFaceUp = true
                count += 1
            }
        }
        
        let result = analyse.computeCombination(playingHand: hand, playingBoard: board)
        labelHand.text = "\(hand[0]) \(hand[1])"
        labelBoard.text = "\(board[0]) \(board[1]) \(board[2]) \(board[3])"
        labelCombination.text = "\(result)"
        let resultDraws = analyseDraws.computeDraws(playingHand: hand, playingBoard: board, currentCombination: result)
        labelPara0.text = String(resultDraws[0][0])
        labelPara1.text = String.init(format: "%0.2f", resultDraws[0][1])
        labelTwoPairs0.text = String(resultDraws[1][0])
        labelTwoPairs1.text = String.init(format: "%0.2f", resultDraws[1][1])
        labelTrips0.text = String(resultDraws[2][0])
        labelTrips1.text = String.init(format: "%0.2f", resultDraws[2][1])
        labelStraight0.text = String(resultDraws[3][0])
        labelStraight1.text = String.init(format: "%0.2f", resultDraws[3][1])
        labelFlush0.text = String(resultDraws[4][0])
        labelFlush1.text = String.init(format: "%0.2f", resultDraws[4][1])
        labelFull0.text = String(resultDraws[5][0])
        labelFull1.text = String.init(format: "%0.2f", resultDraws[5][1])
        labelKare0.text = String(resultDraws[6][0])
        labelKare1.text = String.init(format: "%0.2f", resultDraws[6][1])
        labelStrFlush0.text = String(resultDraws[7][0])
        labelStrFlush1.text = String.init(format: "%0.2f", resultDraws[7][1])
        labelRoyal0.text = String(resultDraws[8][0])
        labelRoyal1.text = String.init(format: "%0.2f", resultDraws[8][1])
        labelSum0.text = String(resultDraws[9][0])
        labelSum1.text = String.init(format: "%0.2f", resultDraws[9][1])
    }
    
}

