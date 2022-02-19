//
//  MemoryGame.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/08.
//

// Model

import Foundation // Not import SwiftUI. This is a model

struct MemoryGame<CardContent> where CardContent: Equatable { // CardContent is a 'dont-care' type generic, but can 'arithmetic' (by equatable)
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?{ // current single faceup card
        get {cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
        set {cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}}
    }
    
    mutating func choose(_ card: Card){ // 'mutating' will change the self struct
        if let chosenIdx = cards.firstIndex(where: { $0.id == card.id}),
           !cards[chosenIdx].isFaceUp,
           !cards[chosenIdx].isMatched {
            if let potentialMatchIdx = indexOfTheOneAndOnlyFaceUpCard{
                // chose and check if its same
                if cards[chosenIdx].content == cards[potentialMatchIdx].content{
                    cards[chosenIdx].isMatched=true
                    cards[potentialMatchIdx].isMatched=true
                }
                cards[chosenIdx].isFaceUp=true // matched, so no oneAndOnlyFaceUpCard.
                // Two cards are face up, so theres no single faceup
            }else{ // card didn't match, so face down cards
               indexOfTheOneAndOnlyFaceUpCard=chosenIdx
            }
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = []
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIdx in 0..<numberOfPairsOfCards{
            let content = createCardContent(pairIdx)
            cards.append(Card(content: content, id: pairIdx*2))
            cards.append(Card(content: content, id: pairIdx*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                }else{
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false{
            didSet{
                stopUsingBonusTime()
            }
        }
        let content: CardContent // CardContent is a dont-care
        let id: Int // content,id is 'let', they don't change
        
        
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array{
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        }else{
            return nil
        }
    }
}
