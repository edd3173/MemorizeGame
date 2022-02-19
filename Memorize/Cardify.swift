//
//  Cardify.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/19.
//

import SwiftUI
  
struct Cardify: AnimatableModifier {
    init(isFaceUp : Bool){
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get{ rotation }
        set{ rotation = newValue}
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content)-> some View {
        ZStack{ // A bag.
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if(rotation < 90) {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }
            else{
               shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1:0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
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
