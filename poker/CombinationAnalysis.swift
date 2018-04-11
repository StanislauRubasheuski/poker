//
//  CombinationAnalysis.swift
//  poker
//
//  Created by Stanislau on 09.04.2018.
//  Copyright © 2018 artur. All rights reserved.
//

import Foundation

class CombinationAnalysis {
    
    enum Combinations: Int, CustomStringConvertible {
        var description: String {
            switch self {
            case .HighCard: return "High Card"
            case .Pair: return "One Pair"
            case .TwoPairs: return "Two Pairs"
            case .ThreeOfAKind: return "Three of a Kind"
            case .Straight: return "Straight"
            case .Flush: return "Flush"
            case .FullHouse: return "Full House"
            case .FourOfAKind: return "Four of a Kind"
            case .StraightFlush: return "Straight Flush"
            case .RoyalFlush: return "Royal Flush"
            }
            
        }
        case HighCard = 0
        case Pair
        case TwoPairs
        case ThreeOfAKind
        case Straight
        case Flush
        case FullHouse
        case FourOfAKind
        case StraightFlush
        case RoyalFlush
    }
    
    func computeCombination(playingHand hand: [PlayingCard], playingBoard board: [PlayingCard]) -> Combinations {
        var countOfCoincidence: Int = 0 // Подсчет совпадений для определения комбинаций
        var countOfMatchedRanks = Array(repeatElement(0, count: 13)) // Массив для учета кол-ва совпадений по Rank
        var countOfMatchedSuits = Array(repeating: 0, count: 4) // Массив для учета кол-ва совпадений по Suit
        var isFlush = false // Для нахождения стрит и роял флеша
        var cards = [PlayingCard]() // Массив карт, которым будем оперировать при поиске комбинаций
        
        cards += hand
        cards += board
        
        // Ищем кол-во совпадений
        for card in cards {
            countOfMatchedRanks[card.rank.order - 1] += 1
            countOfMatchedSuits[card.suit.rawValue] += 1
        }
        
        
        // Ищем совпадение на флеш. Возвращать будем после проверки на роял и стрит флеш
        for index in 0..<countOfMatchedSuits.count {
            if countOfMatchedSuits[index] >= 5 {
                isFlush = true
                break
            }
        }
        
        // Ищем совпадения на роял и стрит флеш и возвращаем данные
        if isFlush {
            for index in 0..<countOfMatchedRanks.count {
                if countOfMatchedRanks[0] >= 1 {
                    if countOfMatchedRanks[1] >= 1 && countOfMatchedRanks[2] >= 1 && countOfMatchedRanks[3] >= 1
                        && countOfMatchedRanks[4] >= 1 {
                        return Combinations.StraightFlush
                    }
                    if countOfMatchedRanks[12] >= 1 && countOfMatchedRanks[11] >= 1 && countOfMatchedRanks[10] >= 1
                        && countOfMatchedRanks[9] >= 1 {
                        return Combinations.RoyalFlush
                    }
                }
                
                if countOfMatchedRanks[index] >= 1 && index < 9 {
                    if countOfMatchedRanks[index + 1] >= 1 && countOfMatchedRanks[index + 2] >= 1
                        && countOfMatchedRanks[index + 3] >= 1 && countOfMatchedRanks[index + 4] >= 1 {
                        return Combinations.StraightFlush
                    }
                }
            }
            return Combinations.Flush
        }
        
        // Ищем совпадения на оставшиеся комбинации
        for index in 0..<countOfMatchedRanks.count {
            if countOfMatchedRanks[index] == 4 {
                return Combinations.FourOfAKind
            }
            
            if countOfMatchedRanks[index] == 3 { // Запоминаем, есть ли совпадения по трем картам
                countOfCoincidence += 3
            }
            
            if countOfMatchedRanks[index] == 2 { // Запоминаем, если ли совпадения по двум картам
                countOfCoincidence += 2
            }
            
            //Тут недочет!!!! Исправить когда-нибудь!!!
            if countOfMatchedRanks[0] >= 1 { // Проверка на стрит с Тузом
                if countOfMatchedRanks[1] >= 1 && countOfMatchedRanks[2] >= 1 && countOfMatchedRanks[3] >= 1
                    && countOfMatchedRanks[4] >= 1 {
                    return Combinations.Straight
                }
                if countOfMatchedRanks[12] >= 1 && countOfMatchedRanks[11] >= 1 && countOfMatchedRanks[10] >= 1
                    && countOfMatchedRanks[9] >= 1 {
                    return Combinations.Straight
                }
            }
            
            if countOfMatchedRanks[index] >= 1 && index < 9 { // На стрит без Туза
                if countOfMatchedRanks[index + 1] >= 1 && countOfMatchedRanks[index + 2] >= 1
                    && countOfMatchedRanks[index + 3] >= 1 && countOfMatchedRanks[index + 4] >= 1 {
                    return Combinations.Straight
                }
            }
        }
        
        if countOfCoincidence == 2 {
            return Combinations.Pair
        }
        
        if countOfCoincidence == 3 {
            return Combinations.ThreeOfAKind
        }
        
        if countOfCoincidence == 4 {
            return Combinations.TwoPairs
        }
        
        if countOfCoincidence == 5 {
            return Combinations.FullHouse
        }
        
        if countOfCoincidence == 6 { // Для ситуаций три пары или две тройки
            for index in 0..<countOfMatchedRanks.count {
                if countOfMatchedRanks[index] == 2 {
                    return Combinations.TwoPairs
                }
                if countOfMatchedRanks[index] == 3 {
                    return Combinations.FullHouse
                }
            }
        }
        return Combinations.HighCard
    }
}
