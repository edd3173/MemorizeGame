//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/08.
//

import SwiftUI



class EmojiMemoryGame{
    
    // Created once, global -> With static
    static let emojis: [String] = ["⚽️","🏀","🏈","⚾️","🎱","🏓","🥋","🎸","🎲","🎮","🧩"]
    // Created once,
    static func createMemoryGame() -> MemoryGame<String>{
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // the generic type is now a String. private(set). Accessable, but Unchangable. Every Instance
    private var model: MemoryGame<String> = createMemoryGame()
    
    
    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
}
