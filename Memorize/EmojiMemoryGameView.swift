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
    @Namespace private var dealingNameSpace
    
    var body: some View { // why Some? why View? type something acts like view
        ZStack(alignment: .bottom){
            gameBody
            VStack{
                deckBody
                HStack{
                    restart
                    Spacer()
                    shuffle
                }
            }
            .padding()
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation{
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}){
            delay = Double(index) * (CardContstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardContstants.dealDuration).delay(delay)
    }
    
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double{
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View{
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if card.isMatched && !card.isFaceUp || isUndealt(card){
                Color.clear
            }else{
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture{
                        withAnimation{
                            game.choose(card) // ask viewmodel to link
                        }
                    }
            }
        }
       
        .foregroundColor(CardContstants.color)
    }
    
    
    var deckBody: some View{
        ZStack{
            ForEach(game.cards.filter(isUndealt)){ card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))

            }
        }
        .frame(width: CardContstants.undealtWidth, height: CardContstants.undealtHeight)
        .foregroundColor(CardContstants.color)
        .onTapGesture {
            // deal acrds
            for card in game.cards{
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
           
        }
    }
    
    var shuffle: some View{
        Button("Shuffle"){
            withAnimation{
                game.shuffle()
            }
        }
    }
    
    var restart: some View{
        Button("Restart"){
            withAnimation{
                dealt=[]
                game.restart()
            }
        }
    }
    
    private struct CardContstants{
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card // Read-Only
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{ // A bag.
                Group{
                    if card.isConsumingBonusTime{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle:Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear{
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)){
                                    animatedBonusRemaining=0
                                }
                            }
                    }else{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle:Angle(degrees: (1-card.bonusRemaining)*360-90))

                    }
                }
                    .padding(7).opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFacedUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants{
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
    
    
}





























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game:game)
    }
}
