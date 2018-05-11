//
//  SetGame.swift
//  Set
//
//  Created by YinYifei on 2018-05-08.
//  Copyright © 2018 Yifei Yin. All rights reserved.
//

import Foundation

class SetGame {

    // MARK: Basic Data Storage
    
    var newCards = [SetCard]()
    var tableCards = [SetCard]()
    var indicesOfCardsSelected = [Int]()
    var discardedCards = [SetCard]()
    
    var maxTableCardsNumber = 24
    
    init() {
        for number in SetCard.Property.all {
            for color in SetCard.Property.all {
                for symbol in SetCard.Property.all {
                    for shading in SetCard.Property.all {
                        newCards.append(SetCard(number: number, color: color, symbol: symbol, shading: shading))
                    }
                }
            }
        }
        
        for _ in 0..<12 {
            let randIndex = Utilities.Rand(upperBound: newCards.count)
            tableCards.append(newCards[randIndex])
            newCards.remove(at: randIndex)
        }
        
    }
    
    // MARK: Computed Properties
    
    var selectedCards: [SetCard] { return tableCards.filter { indicesOfCardsSelected.contains(tableCards.index(of: $0)!) } }
    var numberOfNewCardsRemaining: Int { return newCards.count }
    var matchingStatus: MatchingStatus { return PerformMatchTest() }
    
    func SelectCard(at index: Int) {
        if indicesOfCardsSelected.contains(index) {
            indicesOfCardsSelected.remove(at: indicesOfCardsSelected.index(of: index)!)
        } else {
            if matchingStatus == .match || matchingStatus == .mismatch {
                indicesOfCardsSelected.removeAll()
            }
            indicesOfCardsSelected.append(index)
        }
    }
    
    enum MatchingStatus {
        case match
        case mismatch
        case notApplicable
    }
    
    private func PerformMatchTest() -> MatchingStatus {
        // TODO: Fix logic
        if selectedCards.count < 3 { return .notApplicable }
        assert(selectedCards.count < 4)
        
        for possibleCommonPropertyIndex in selectedCards[0].properties.indices {
            for possibleDifferPropertyIndex in selectedCards[0].properties.indices {
                if possibleDifferPropertyIndex == possibleCommonPropertyIndex {
                    continue
                }
                var possibleCommonProperties = [SetCard.Property]()
                var possibleDifferProperties = [SetCard.Property]()
                for index in selectedCards.indices {
                    possibleCommonProperties.append(selectedCards[index].properties[possibleCommonPropertyIndex])
                    possibleDifferProperties.append(selectedCards[index].properties[possibleDifferPropertyIndex])
                }
                
                if TripleTest(possibleCommonProperties) == .identical &&
                    TripleTest(possibleDifferProperties) == .unique {
                    return .match
                }
            }
        }
        return .mismatch
    }
    
    private enum TripleTestResult {
        case identical
        case unique
        case others
    }
        
    private func TripleTest(_ properties: [SetCard.Property]) -> TripleTestResult {
        assert(properties.count == 3)
        
        if properties[0] == properties[1] && properties[1] == properties[2] {
            return .identical
        }
        
        if properties[0] != properties[1] &&
            properties[1] != properties[2] &&
            properties[0] != properties[2] {
            return .unique
        }
        return .others
    }
    
    func DealThreeMoreCards() {
        if matchingStatus == .match {
            indicesOfCardsSelected.forEach {
                let randIndex = Utilities.Rand(upperBound: newCards.count)
                discardedCards.append(tableCards[$0])
                tableCards[$0] = newCards[randIndex]
                newCards.remove(at: randIndex)
            }
            indicesOfCardsSelected.removeAll()
        } else if tableCards.count + 3 <= maxTableCardsNumber {
            for _ in 0..<3 {
                let randIndex = Utilities.Rand(upperBound: newCards.count)
                tableCards.append(newCards[randIndex])
                newCards.remove(at: randIndex)
            }
        }
    }
}

struct Utilities {
    static func Rand(upperBound max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}
















