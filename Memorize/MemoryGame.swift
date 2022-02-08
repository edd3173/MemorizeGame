//
//  MemoryGame.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/08.
//

import Foundation // Not import SwiftUI. This is a model

struct MemoryGame<CardContent>{ // CardContent is a 'dont-care' type generic.
    private(set) var cards: Array<Card>
    
    func choose(_ card: Card){
        
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = Array<Card>()
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIdx in 0..<numberOfPairsOfCards{
            let content = createCardContent(pairIdx)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent // CardContent is a dont-care
    }
    
}
