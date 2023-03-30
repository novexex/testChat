//
//  MainView.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var userViewModel = UserViewModel()
    
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
            ProfileView(user: userViewModel.user)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
    
    init() {
        userViewModel.fetchUser()
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
