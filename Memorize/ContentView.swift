//
//  ContentView.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/05.
//

import SwiftUI

struct ContentView: View { // This structure acts as View
    var body: some View { // why Some? why View? type something acts like view
        return ZStack(content: { // A bag.
            RoundedRectangle(cornerRadius: 20.0)
                .stroke(lineWidth: 3)
                .padding(.horizontal)
                .foregroundColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)

            Text("Hello, world!")
                .foregroundColor(.blue)
                .padding()
    
        })
        
    }
}





























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
