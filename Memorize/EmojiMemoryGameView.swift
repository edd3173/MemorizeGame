//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/05.
//


// UI - View


import SwiftUI

struct EmojiMemoryGameView: View { // This structure acts as View
    // OO : something changed, rebuild entire bdoy
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View { // why Some? why View? type something acts like view

        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if card.isMatched && !card.isFaceUp{
                Rectangle().opacity(0)
            }else{

                CardView(card: card)
                    .padding(4)
                    .onTapGesture{
                        game.choose(card) // ask viewmodel to link
                    }
            }
        }
                
        .foregroundColor(.red)
        .padding(.horizontal)
    }
    
}

struct CardView: View {
    let card: EmojiMemoryGame.Card // Read-Only
    
    
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{ // A bag.
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                
                if(card.isFaceUp) {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle:Angle(degrees: 110-90)).padding(7).opacity(0.5)
                    Text(card.content).font(font(in: geometry.size))
                    
                }
                else if card.isMatched{
                    shape.opacity(0)
                }
                else{
                   shape.fill()
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants{
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
    
    
}





























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game:game)
    }
}
