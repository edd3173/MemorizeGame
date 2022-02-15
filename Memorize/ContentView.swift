//
//  ContentView.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/05.
//


// UI - View


import SwiftUI

struct ContentView: View { // This structure acts as View
    // OO : something changed, rebuild entire body
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View { // why Some? why View? type something acts like view
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture{
                            viewModel.choose(card) // ask viewmodel to link
                        }
                }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
    
}

struct CardView: View {
    let card: MemoryGame<String>.Card // Read-Only
    
    var body: some View {
        ZStack{ // A bag.
            let shape = RoundedRectangle(cornerRadius: 20.0)
            
            if(card.isFaceUp) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
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





























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
