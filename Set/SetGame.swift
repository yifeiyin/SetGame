//
//  SetGame.swift
//  Set
//
//  Created by YinYifei on 2018-05-08.
//  Copyright © 2018 Yifei Yin. All rights reserved.
//

import Foundation

class SetGame {

    // MARK: Basic Data
    
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
    var isAbleToDealThreeMoreCards: Bool { return tableCards.count + 3 <= maxTableCardsNumber && newCards.count > 0 }
    var isGameCompleted: Bool { return newCards.isEmpty && tableCards.isEmpty }
    
    // MARK: Actions
    
    func DealThreeMoreCards() {
        
        if matchingStatus == .match {
            tableCards.remove(at: indicesOfCardsSelected)
            indicesOfCardsSelected.removeAll()
        }
        
        if !isAbleToDealThreeMoreCards { return }
        
        for _ in 0..<3 {
            let randIndex = Utilities.Rand(upperBound: newCards.count)
            tableCards.append(newCards[randIndex])
            newCards.remove(at: randIndex)
        }
    }
    
    func SelectCard(card newSelectedCard: SetCard) {
        let isInSelection = selectedCards.contains(newSelectedCard)
        switch matchingStatus {
        case .match:
            RemoveTableCards(at: indicesOfCardsSelected)
            indicesOfCardsSelected.removeAll()
            if !isInSelection { indicesOfCardsSelected.append(tableCards.index(of: newSelectedCard)!) }
        case .mismatch:
            indicesOfCardsSelected.removeAll()
            indicesOfCardsSelected.append(tableCards.index(of: newSelectedCard)!)
        case .tooFewCards:
            if selectedCards.contains(newSelectedCard) {
                indicesOfCardsSelected.remove(at: indicesOfCardsSelected.index(of: tableCards.index(of: newSelectedCard)!)!)
            } else {
                indicesOfCardsSelected.append(tableCards.index(of: newSelectedCard)!)
            }
        }
        
        while numberOfSetsOnTable == 0 {
            DealThreeMoreCards()
        }
    }
    
    
    
    // MARK: Hints
    
    var numberOfSetsOnTable: Int { return ComputeSetsOnTable().count }
    private func ComputeSetsOnTable() -> [[SetCard]] {
        var sets = [[SetCard]]()
        let max = tableCards.count
        for i in 0..<max {
            for j in i+1..<max {
                for k in j+1..<max {
                    if PerformMatchTest(for: [tableCards[i], tableCards[j], tableCards[k]]) == .match {
                        sets.append([tableCards[i], tableCards[j], tableCards[k]])
                    }
                }
            }
        }
        return sets
    }
    
    private var _lastHintIndex = 0
    private var _isShowingHint = false
    func ShowHint() {
        let setsOnTable = ComputeSetsOnTable()
        
        if setsOnTable.isEmpty {
            _isShowingHint = false
            return
        }
        
        if _isShowingHint {
            _isShowingHint = false
            indicesOfCardsSelected.removeAll()
            return
        }
        
        var newHintIndex = _lastHintIndex + 1
        if newHintIndex >= setsOnTable.count {
            newHintIndex = 0
        }
    
        indicesOfCardsSelected = indexInTableCard(of: setsOnTable[newHintIndex])
        _isShowingHint = true
        _lastHintIndex = newHintIndex

    }
    
    // MARK: Private funcs
    
    private func RemoveTableCards(at indices: [Int]) {
        indices.forEach {
            discardedCards.append(tableCards[$0])
        }
        tableCards.remove(at: indices)
    }
    
    func indexInTableCard(of card: SetCard) -> Int? {
        return tableCards.index(of: card)
    }
    
    func indexInTableCard(of cards: [SetCard]) -> [Int] {
        var out = [Int]()
        cards.forEach {
            if let index = indexInTableCard(of: $0) {
                out.append(index)
            }
        }
        return out
    }
    
    enum MatchingStatus {
        case match
        case mismatch
        case tooFewCards
    }
    
    private func PerformMatchTest(for _cards: [SetCard]? = nil) -> MatchingStatus {
        var cards = [SetCard]()
        if _cards == nil {
            cards = selectedCards
        } else {
            cards = _cards!
        }
        
        if cards.count < 3 { return .tooFewCards }
        assert(cards.count < 4)

        for propertyIndex in 0..<4 {
            if TripleTest([cards[0].properties[propertyIndex],
                           cards[1].properties[propertyIndex],
                           cards[2].properties[propertyIndex]]) == .others
            {
                return .mismatch
            }
        }
        return .match
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
    
    
    
    
    

}

struct Utilities {
    static func Rand(upperBound max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}
















