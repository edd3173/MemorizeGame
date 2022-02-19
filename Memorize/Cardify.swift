//
//  Cardify.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/19.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    
    func body(content: Content)-> some View {
        ZStack{ // A bag.
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if(isFaceUp) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }
            else{
               shape.fill()
            }
            content
                .opacity(isFaceUp ? 1:0)
        }
    }
    
    private struct DrawingConstants{
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View{
    func cardify(isFacedUp:Bool) -> some View{
        return self.modifier(Cardify(isFaceUp: isFacedUp))
    }
}
