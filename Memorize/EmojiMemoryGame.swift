//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/08.
//


// ViewModel

import SwiftUI


class EmojiMemoryGame : ObservableObject{ // oo : publish the world if something change
    
    // Created once, global -> With static
    static let emojis: [String] = ["⚽️","🏀","🏈","⚾️","🎱","🏓","🥋","🎸","🎲","🎮","🧩"]
    
    // Created once,
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in // here, pairIndex is like arg of function after IN : emojis[pariIdx]
            emojis[pairIndex]
        }
    }
    
    // the generic type is now a String. private(set). Accessable, but Unchangable. Every Instance
    // For Static Func (and initializer), need not to read like EmojiMemoryGame.createMemoryGame()
    
    // Published : If something changed, publish to world
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card){ // now call model's func
        model.choose(card)
    }
}
