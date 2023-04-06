//
//  testChatApp.swift
//  testChat
//
//  Created by Artour Ilyasov on 28.03.2023.
//

import SwiftUI

// TODO: Should try send avatar data with JWT again
// TODO: Insert JWT in project

@main
struct testChatApp: App {
    var body: some Scene {
        WindowGroup {
            AuthorizationView()
        }
    }
}
