//
//  ContentView.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/05.
//

import SwiftUI

struct ContentView: View { // This structure acts as View
    
    var emojis: [String] = ["⚽️","🏀","🏈","⚾️","🎱","🏓","🥋","🎸","🎲","🎮","🧩"]
    @State var emojiCount = 10
    
    var body: some View { // why Some? why View? type something acts like view
        VStack{
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
        }
      
        .padding(.horizontal)
      
        
    }
    
}

struct CardView: View {
    var content : String
    @State var isFaceUp : Bool = true
    
    var body: some View {
        ZStack{ // A bag.
            let shape = RoundedRectangle(cornerRadius: 20.0)
            
            if(isFaceUp) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            }
            else{
               shape.fill()
            }
        }
        .onTapGesture{
            isFaceUp = !isFaceUp
        }
    }
}





























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
