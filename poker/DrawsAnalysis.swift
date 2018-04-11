//
//  DrawsAnalysis.swift
//  poker
//
//  Created by Stanislau on 09.04.2018.
//  Copyright © 2018 artur. All rights reserved.
//

import Foundation

class DrawsAnalysis {
    
    private var isFlushDraw = false
    private var isStraightFlushOrRoyalFlushDraw = false
    private var is2StraightFlushDraw = false // Есть ли двустороннее стрейт флеш дро
    
    func computeDraws(playingHand hand: [PlayingCard], playingBoard board: [PlayingCard], currentCombination combination: CombinationAnalysis.Combinations) -> [[Double]] {
        
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
        
        let countOfPlayingCards = cards.count
        
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
        if countOfPlayingCards == 7 {
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
            resultFourOfAKindDraw = fourOfAKindDraw(countCards: countOfPlayingCards, countCoincidence: countOfCoincidence)
            result[6][0] = resultFourOfAKindDraw.0
            result[6][1] = resultFourOfAKindDraw.1
            resultSummOutsAndOdds = summOutsAndOdds(result: result)
            result[9][0] = resultSummOutsAndOdds.0
            result[9][1] = resultSummOutsAndOdds.1
            return result
        case .Flush:
            resultRoyalFlushDraw = royalFlushDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks, countSuit: countOfMatchedSuits)
            result[8][0] = resultRoyalFlushDraw.0
            result[8][1] = resultRoyalFlushDraw.1
            resultStraightFlushDraw = straightFlushDraw(cards: cards, countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[7][0] = resultStraightFlushDraw.0
            result[7][1] = resultStraightFlushDraw.1
            resultSummOutsAndOdds = summOutsAndOdds(result: result)
            result[9][0] = resultSummOutsAndOdds.0
            result[9][1] = resultSummOutsAndOdds.1
            return result
        case .Straight:
            resultRoyalFlushDraw = royalFlushDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks, countSuit: countOfMatchedSuits)
            result[8][0] = resultRoyalFlushDraw.0
            result[8][1] = resultRoyalFlushDraw.1
            resultStraightFlushDraw = straightFlushDraw(cards: cards, countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[7][0] = resultStraightFlushDraw.0
            result[7][1] = resultStraightFlushDraw.1
            resultFlushDraw = flushDraw(countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[4][0] = resultFlushDraw.0
            result[4][1] = resultFlushDraw.1
            resultSummOutsAndOdds = summOutsAndOdds(result: result)
            result[9][0] = resultSummOutsAndOdds.0
            result[9][1] = resultSummOutsAndOdds.1
            return result
        case .ThreeOfAKind:
            resultFourOfAKindDraw = fourOfAKindDraw(countCards: countOfPlayingCards, countCoincidence: countOfCoincidence)
            result[6][0] = resultFourOfAKindDraw.0
            result[6][1] = resultFourOfAKindDraw.1
            resultFullHouseDraw = fullHouseDraw(countCards: countOfPlayingCards, countCoincidence: countOfCoincidence)
            result[5][0] = resultFullHouseDraw.0
            result[5][1] = resultFullHouseDraw.1
            resultRoyalFlushDraw = royalFlushDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks, countSuit: countOfMatchedSuits)
            result[8][0] = resultRoyalFlushDraw.0
            result[8][1] = resultRoyalFlushDraw.1
            resultStraightFlushDraw = straightFlushDraw(cards: cards, countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[7][0] = resultStraightFlushDraw.0
            result[7][1] = resultStraightFlushDraw.1
            resultFlushDraw = flushDraw(countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[4][0] = resultFlushDraw.0
            result[4][1] = resultFlushDraw.1
            resultStraightDraw = straightDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks)
            result[3][0] = resultStraightDraw.0
            result[3][1] = resultStraightDraw.1
            resultSummOutsAndOdds = summOutsAndOdds(result: result)
            result[9][0] = resultSummOutsAndOdds.0
            result[9][1] = resultSummOutsAndOdds.1
            return result
        case .TwoPairs:
            resultRoyalFlushDraw = royalFlushDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks, countSuit: countOfMatchedSuits)
            result[8][0] = resultRoyalFlushDraw.0
            result[8][1] = resultRoyalFlushDraw.1
            resultStraightFlushDraw = straightFlushDraw(cards: cards, countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[7][0] = resultStraightFlushDraw.0
            result[7][1] = resultStraightFlushDraw.1
            resultFlushDraw = flushDraw(countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[4][0] = resultFlushDraw.0
            result[4][1] = resultFlushDraw.1
            resultFullHouseDraw = fullHouseDraw(countCards: countOfPlayingCards, countCoincidence: countOfCoincidence)
            result[5][0] = resultFullHouseDraw.0
            result[5][1] = resultFullHouseDraw.1
            resultStraightDraw = straightDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks)
            result[3][0] = resultStraightDraw.0
            result[3][1] = resultStraightDraw.1
            resultSummOutsAndOdds = summOutsAndOdds(result: result)
            result[9][0] = resultSummOutsAndOdds.0
            result[9][1] = resultSummOutsAndOdds.1
            return result
        case .Pair:
            resultRoyalFlushDraw = royalFlushDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks, countSuit: countOfMatchedSuits)
            result[8][0] = resultRoyalFlushDraw.0
            result[8][1] = resultRoyalFlushDraw.1
            resultStraightFlushDraw = straightFlushDraw(cards: cards, countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[7][0] = resultStraightFlushDraw.0
            result[7][1] = resultStraightFlushDraw.1
            resultFlushDraw = flushDraw(countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[4][0] = resultFlushDraw.0
            result[4][1] = resultFlushDraw.1
            resultStraightDraw = straightDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks)
            result[3][0] = resultStraightDraw.0
            result[3][1] = resultStraightDraw.1
            resultTwoPairsDraw = twoPairsDraw(countCards: countOfPlayingCards)
            result[1][0] = resultTwoPairsDraw.0
            result[1][1] = resultTwoPairsDraw.1
            resultThreeOfAKindDraw = threeOfAKindDraw(countCards: countOfPlayingCards)
            result[2][0] = resultThreeOfAKindDraw.0
            result[2][1] = resultThreeOfAKindDraw.1
            resultSummOutsAndOdds = summOutsAndOdds(result: result)
            result[9][0] = resultSummOutsAndOdds.0
            result[9][1] = resultSummOutsAndOdds.1
            return result
        case .HighCard:
            resultRoyalFlushDraw = royalFlushDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks, countSuit: countOfMatchedSuits)
            result[8][0] = resultRoyalFlushDraw.0
            result[8][1] = resultRoyalFlushDraw.1
            resultStraightFlushDraw = straightFlushDraw(cards: cards, countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[7][0] = resultStraightFlushDraw.0
            result[7][1] = resultStraightFlushDraw.1
            resultFlushDraw = flushDraw(countCards: countOfPlayingCards, countSuit: countOfMatchedSuits)
            result[4][0] = resultFlushDraw.0
            result[4][1] = resultFlushDraw.1
            resultStraightDraw = straightDraw(countCards: countOfPlayingCards, countRank: countOfMatchedRanks)
            result[3][0] = resultStraightDraw.0
            result[3][1] = resultStraightDraw.1
            resultPairDraw = pairDraw(countCards: countOfPlayingCards)
            result[0][0] = resultPairDraw.0
            result[0][1] = resultPairDraw.1
            resultSummOutsAndOdds = summOutsAndOdds(result: result)
            result[9][0] = resultSummOutsAndOdds.0
            result[9][1] = resultSummOutsAndOdds.1
            return result
        }
    }
    
    /*
     Функция royalFlushDraw
     Входные данные:
     countCards - содержит кол-во играющих карт. Если подтвердится что дро есть, понадобиться для определения флоп это или терн
     countRank - массив учета совпадений по карточным рангам
     countSuit - массив учета совпадений по масти
     Логика:
     Прогоняем countSuit на определение есть ли флеш или флеш дро. Если есть, смотрим на вероятность роял флеш, если нет возвращаем нули.
     Смотрим, есть ли в массиве countRank совпадения на старшие ранги. Если есть, записываем +1 в пер. countOfTopCards.
     Если countOfTopCard == 4, возвращаем шансы усилиться в зависимости от улицы розыгрыша. Если нет, возвращаем нули.
    */
    
    private func royalFlushDraw(countCards: Int, countRank: [Int], countSuit: [Int]) -> (Double, Double) {
        for index in 0..<countSuit.count {
            if countSuit[index] >= 4 {
                var countOfTopCards = 0
                for index in 9...12 {
                    if countRank[index] >= 1 {
                        countOfTopCards += 1
                    }
                }
                if countRank[0] >= 1 {
                    countOfTopCards += 1
                }
                if countOfTopCards == 4 {
                    if countCards == 5{
                        isStraightFlushOrRoyalFlushDraw = true
                        return (1, 1/47*100)
                    } else {
                        isStraightFlushOrRoyalFlushDraw = true
                        return (1, 1/46*100)
                    }
                } else {
                    return (0,0)
                }
            }
        }
        return (0,0)
    }
    
    //AAAAA!!!!!!!!
    private func straightFlushDraw(cards: [PlayingCard], countCards: Int, countSuit: [Int]) -> (Double, Double) {
        for index in 0..<countSuit.count {
            if countSuit[index] >= 4 {
                var consecutiveCards = 0
                var countSuitCards = 0
                var flushDrawCards = Array(repeating: 0, count: 13)
                for card in cards {
                    if card.suit.rawValue == index {
                        countSuitCards += 1
                        flushDrawCards[card.rank.order - 1] += 1
                    }
                }
                if countSuitCards < 5 {
                    for index in 0..<flushDrawCards.count {
                        if flushDrawCards[index] == 1 {
                            for ind in (index + 1)...(index + 4) {
                                if consecutiveCards == 3 {
                                    break
                                }
                                if flushDrawCards[ind] == 1 {
                                    consecutiveCards += 1
                                } else {
                                    consecutiveCards -= 1
                                }
                            }
                            if consecutiveCards == 3 {
                                if countCards == 5{
                                    is2StraightFlushDraw = true
                                    return (2, 2/47*100)
                                } else {
                                    is2StraightFlushDraw = true
                                    return (2, 2/46*100)
                                }
                            } else if consecutiveCards == 2 {
                                if countCards == 5{
                                    isStraightFlushOrRoyalFlushDraw = true
                                    return (1, 1/47*100)
                                } else {
                                    isStraightFlushOrRoyalFlushDraw = true
                                    return (1, 1/46*100)
                                }
                            } else {
                                return (0,0)
                            }
                        }
                    }
                } else {
                    for index in 0..<flushDrawCards.count {
                        if flushDrawCards[index] == 1 && flushDrawCards[index + 1] == 1 && index < 9 {
                            for ind in (index + 1)...(index + 4) {
                                if consecutiveCards == 3 {
                                    break
                                }
                                if flushDrawCards[ind] == 1 {
                                    consecutiveCards += 1
                                } else {
                                    consecutiveCards -= 1
                                }
                            }
                            if consecutiveCards == 3 {
                                if countCards == 5{
                                    is2StraightFlushDraw = true
                                    return (2, 2/47*100)
                                } else {
                                    is2StraightFlushDraw = true
                                    return (2, 2/46*100)
                                }
                            } else if consecutiveCards == 2 {
                                if countCards == 5{
                                    isStraightFlushOrRoyalFlushDraw = true
                                    return (1, 1/47*100)
                                } else {
                                    isStraightFlushOrRoyalFlushDraw = true
                                    return (1, 1/46*100)
                                }
                            } else {
                                return (0,0)
                            }
                        }
                        if flushDrawCards[index] == 1 && flushDrawCards[index + 2] == 1 && index < 9 {
                            for ind in (index + 3)...(index + 4) {
                                if flushDrawCards[ind] == 1 {
                                    consecutiveCards += 1
                                } else {
                                    consecutiveCards -= 1
                                }
                            }
                            if consecutiveCards == 2 {
                                if countCards == 5 {
                                    isStraightFlushOrRoyalFlushDraw = true
                                    return (1, 1/47*100)
                                } else {
                                    isStraightFlushOrRoyalFlushDraw = true
                                    return (1, 1/46*100)
                                }
                            } else {
                                return (0,0)
                            }
                        }
                    }
                    return (0,0)
                }
            }
        }
        return (0,0)
    }
    
    private func fourOfAKindDraw(countCards: Int, countCoincidence: Int) -> (Double, Double) {
        if countCoincidence == 6 {
            if countCards == 5 {
                return (2, 2/47*100)
            } else {
                return (2, 2/46*100)
            }
        } else {
            if countCards == 5 {
                return (1, 1/47*100)
            } else {
                return (1, 1/46*100)
            }
        }
    }
    
    private func fullHouseDraw(countCards: Int, countCoincidence: Int) -> (Double, Double) {
        if countCoincidence == 3 {
            if countCards == 5{
                return (6, 6/47*100)
            } else {
                return (9, 9/46*100)
            }
        } else if countCoincidence == 4 {
            if countCards == 5 {
                return (4, 4/47*100)
            } else {
                return (4, 4/46*100)
            }
        } else {
            return (6, 6/46*100)
        }
    }
    
    private func flushDraw(countCards: Int, countSuit: [Int]) -> (Double, Double) {
        for index in 0..<countSuit.count {
            if countSuit[index] == 4 {
                if countCards == 5 {
                    if isStraightFlushOrRoyalFlushDraw {
                        isFlushDraw = true
                        return (8, 8/47*100)
                    } else if is2StraightFlushDraw {
                        isFlushDraw = true
                        return (7, 7/47*100)
                    } else {
                        isFlushDraw = true
                        return (9, 9/47*100)
                    }
                } else {
                    if isStraightFlushOrRoyalFlushDraw {
                        isFlushDraw = true
                        return (8, 8/46*100)
                    } else if is2StraightFlushDraw {
                        isFlushDraw = true
                        return (7, 7/46*100)
                    } else {
                        isFlushDraw = true
                        return (9, 9/46*100)
                    }
                }
            }
        }
        return (0,0)
    }
    
    private func straightDraw(countCards: Int, countRank: [Int]) -> (Double, Double) {
        for index in 1...8 {
            var sequenceCount = 0
            if countRank[index] >= 1 {
                for ind in (index + 1)...(index + 4) {
                    if sequenceCount == 3 {
                        break
                    }
                    if countRank[ind] >= 1 {
                        sequenceCount += 1
                    } else {
                        sequenceCount -= 1
                    }
                }
            }
            if sequenceCount == 3{
                if countCards == 5 {
                    if isFlushDraw {
                        return (6, 6/47*100)
                    } else {
                        return (8, 8/47*100)
                    }
                } else {
                    if isFlushDraw {
                        return (6, 6/46*100)
                    } else {
                        return (8, 8/46*100)
                    }
                }
            }
            if sequenceCount == 2 {
                if countCards == 5 {
                    if isFlushDraw {
                        return (3, 3/47*100)
                    } else {
                        return (4, 4/47*100)
                    }
                } else {
                    if isFlushDraw {
                        return (3, 3/46*100)
                    } else {
                        return (4, 4/46*100)
                    }
                }
            }
        }

        
        if countRank[0] >= 1 { // Стрит дро с тузом
            var sequenceCount = 0
            for index in 1...4 {
                if countRank[index] >= 1 {
                    sequenceCount += 1
                }
            }
            if sequenceCount == 3 {
                if countCards == 5 {
                    if isFlushDraw {
                        return (3, 3/47*100)
                    } else {
                        return (4, 4/47*100)
                    }
                } else {
                    if isFlushDraw {
                        return (3, 3/46*100)
                    } else {
                        return (4, 4/46*100)
                    }
                }
            }
            sequenceCount = 0
            for index in 9...12 {
                if countRank[index] >= 1 {
                    sequenceCount += 1
                }
            }
            if sequenceCount == 3 {
                if countCards == 5 {
                    if isFlushDraw {
                        return (3, 3/47*100)
                    } else {
                        return (4, 4/47*100)
                    }
                } else {
                    if isFlushDraw {
                        return (3, 3/46*100)
                    } else {
                        return (4, 4/46*100)
                    }
                }
            }
        }
        return (0,0)
    }
    
    private func threeOfAKindDraw(countCards: Int) -> (Double, Double) {
        if countCards == 5 {
            return (2, 2/47*100)
        } else {
            return (2, 2/46*100)
        }
    }
    
    private func twoPairsDraw(countCards: Int) -> (Double, Double) {
        if countCards == 5 {
            return (9, 9/47*100)
        } else {
            return (12, 12/46*100)
        }
    }
    
    private func pairDraw(countCards: Int) -> (Double, Double) {
        if countCards == 5 {
            if isFlushDraw {
                return (14, 14/47*100)
            } else {
                return (15, 15/47*100)
            }
        } else {
            if isFlushDraw {
                return (14, 16/46*100)
            } else {
                return (18, 18/46*100)
            }
        }
    }
    
    private func summOutsAndOdds(result: [[Double]]) -> (Double, Double) {
        var summOuts: Double = 0
        var summOdds: Double = 0
        for index in 0..<result.count {
            summOuts += result[index][0]
            summOdds += result[index][1]
        }
        return (summOuts, summOdds)
    }
}
