//
//  DrawsAnalysis.swift
//  poker
//
//  Created by Stanislau on 09.04.2018.
//  Copyright © 2018 artur. All rights reserved.
//

import Foundation

class DrawsAnalysis {
    /*func computeDraws(playingHand hand: [PlayingCard], playingBoard board: [PlayingCard], currentCombination combination: CombinationAnalysis.Combinations) -> [[Double]] {
        
        var result = Array(repeatElement(Array(repeating: 0.0, count: 2), count: 10))
        
        /*
         В двумерный массив result сохраняем ауты и вероятность усилиться по каждой позиции:
         0 - Пара
         1 - Две пары
         2 - Трипс
         3 - Стрит
         4 - Флеш
         5 - Фулл Хаус
         6 - Каре
         7 - Стрит Флеш
         8 - Роял Флеш
         9 - Сумма аутов и вероятностей усилиться
        */
        
        var resultRoyalFlushDraw: (Double, Double)
        var resultStraightFlushDraw: (Double, Double)
        var resultFourOfAKindDraw: (Double, Double)
        var resultFullHouseDraw: (Double, Double)
        var resultFlushDraw: (Double, Double)
        var resultStraightDraw: (Double, Double)
        var resultThreeOfAKindDraw: (Double, Double)
        var resultTwoPairsDraw: (Double, Double)
        var resultPairDraw: (Double, Double)
        var resultSummOutsAndOdds: (Double, Double)
        
        var countOfCoincidence: Int = 0 // Подсчет совпадений для определения комбинаций
        var countOfMatchedRanks = Array(repeatElement(0, count: 13)) // Массив для учета кол-ва совпадений по Rank
        var countOfMatchedSuits = Array(repeating: 0, count: 4) // Массив для учета кол-ва совпадений по Suit
        var cards = [PlayingCard]() // Массив карт, которым будем оперировать при поиске комбинаций
        
        cards += hand
        cards += board
        
        var countOfPlayingCards = cards.count
        
        // Ищем кол-во совпадений
        for card in cards {
            countOfMatchedRanks[card.rank.order - 1] += 1
            countOfMatchedSuits[card.suit.rawValue] += 1
        }
        
        for index in 0..<countOfMatchedRanks.count {
            if countOfMatchedRanks[index] == 3 { // Запоминаем, есть ли совпадения по трем картам
                countOfCoincidence += 3
            }
            
            if countOfMatchedRanks[index] == 2 { // Запоминаем, если ли совпадения по двум картам
                countOfCoincidence += 2
            }
        }
        
        //Если карт 7, значит мы на ривере, значит раздача карт закончена - возвращаем нули
        if cards.count == 7 {
            return result
        }
        
        switch combination {
        case .RoyalFlush:
            return result
        case .StraightFlush:
            resultRoyalFlushDraw = royalFlushDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks, countSuit: countOfMatchedSuits)
            result[8][0] = resultRoyalFlushDraw.0
            result[8][1] = resultRoyalFlushDraw.1
            resultSummOutsAndOdds = summOutsAndOdds(result: result)
            result[9][0] = resultSummOutsAndOdds.0
            result[9][1] = resultSummOutsAndOdds.1
            return result
        case .FourOfAKind:
            return result
        case .FullHouse:
        case .Flush:
        case .Straight:
        case .ThreeOfAKind:
        case .TwoPairs:
        case .Pair:
        case .HighCard:
        }
        
        return result
    }
    
    private func royalFlushDraw(countCards: Int, countRank: [Int], countSuit: [Int]) -> (Double, Double) {
        
    }
    
    private func straightFlushDraw(countCards: Int, countRank: [Int], countSuit: [Int]) -> (Double, Double) {
        
    }
    
    private func fourOfAKindDraw(countCards: Int, countRank: [Int], countCoincidence: Int) -> (Double, Double) {
        
    }
    
    private func fullHouseDraw(countCards: Int, countCoincidence: Int) -> (Double, Double) {
        
    }
    
    private func flushDraw(countCards: Int, countSuit: [Int]) -> (Double, Double) {
        
    }
    
    private func straightDraw(countCards: Int, countRank: [Int]) -> (Double, Double) {
        
    }
    
    private func threeOfAKindDraw(countCards: Int) -> (Double, Double) {
        
    }
    
    private func twoPairsDraw() -> (Double, Double) {
        
    }
    
    private func pairDraw() -> (Double, Double) {
        
    }
    
    private func summOutsAndOdds(result: [[Double]]) -> (Double, Double) {
        var summOuts: Double = 0
        var summOdds: Double = 0
        for index in 0..<result.count {
            summOuts += result[index][0]
            summOdds += result[index][1]
        }
        return (summOuts, summOdds)
    } */
}
