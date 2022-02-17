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
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = []
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIdx in 0..<numberOfPairsOfCards{
            let content = createCardContent(pairIdx)
            cards.append(Card(content: content, id: pairIdx*2))
            cards.append(Card(content: content, id: pairIdx*2+1))
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp = true
        var isMatched = false
        let content: CardContent // CardContent is a dont-care
        let id: Int // content,id is 'let', they don't change
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
