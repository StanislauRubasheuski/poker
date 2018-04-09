//
//  PlayingCard.swift
//  poker
//
//  Created by artur on 05.04.2018.
//  Copyright © 2018 artur. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    
    var description: String {
        return "\(rank)\(suit)"
    }
    
    var suit: Suit
    var rank: Rank
    var isFaceUp = false
    
    enum Suit: Int, CustomStringConvertible {
        
        case hearts = 0
        case clubs = 1
        case diamonds = 2
        case spades = 3
        
        static var all = [Suit.hearts, .clubs, .diamonds, .spades]
        
        var description: String {
            switch self {
            case .hearts: return "❤️"
            case .clubs: return "♣️"
            case .diamonds: return "♦️"
            case .spades: return "♠️"
            }
        }
    }
    
    enum Rank: CustomStringConvertible {
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
        
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
    }
}
