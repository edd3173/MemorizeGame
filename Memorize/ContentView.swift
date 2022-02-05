//
//  ContentView.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/05.
//

import SwiftUI

struct ContentView: View { // This structure acts as View
    var body: some View { // why Some? why View? type something acts like view
        ZStack{ // A bag.
            RoundedRectangle(cornerRadius: 20.0)
                .stroke(lineWidth: 3)
            Text("Hello, world!")
        }
        .padding(.horizontal)
        .foregroundColor(.red)

        
    }
}





























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
