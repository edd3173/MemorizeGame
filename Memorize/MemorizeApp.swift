//
//  MemorizeApp.swift
//  Memorize
//
//  Created by 원성현 on 2022/02/05.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
