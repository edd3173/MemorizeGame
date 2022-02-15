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
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? // current single faceup card
    
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
                // Two cards are face up, so theres no single faceup
                indexOfTheOneAndOnlyFaceUpCard = nil
            }else{ // card didn't match, so face down cards
                for index in cards.indices{
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIdx // updated.
            }
            cards[chosenIdx].isFaceUp.toggle()
            //print("\(cards)")
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = Array<Card>()
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIdx in 0..<numberOfPairsOfCards{
            let content = createCardContent(pairIdx)
            cards.append(Card(content: content, id: pairIdx*2))
            cards.append(Card(content: content, id: pairIdx*2+1))
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent // CardContent is a dont-care
        var id: Int
    }
}
