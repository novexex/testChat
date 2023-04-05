//
//  MainView.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userObject = NetworkObject()
    
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
            ProfileView(userObject: userObject)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
    
    init() {
        userObject.fetchUser()
    }
}
