//
//  ChatView.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import SwiftUI

struct Chat: Identifiable {
    let id: Int
    let title: String
    let image: String
    let lastMessage: String
}

struct ChatDetailView: View {
    let chat: Chat
    
    var body: some View {
        Text("Детали чата \(chat.title)")
    }
}


struct ChatView: View {
    
    let chats = [
        Chat(id: 1, title: "John", image: "person.circle", lastMessage: "You: Ferrars all spirits his imagine effects amongst neither. It bachelor cheerful of mistaken."),
        Chat(id: 2, title: "Sam", image: "person.circle", lastMessage: "Do play they miss give so up. Words to up style of since world."),
        Chat(id: 3, title: "Nicola", image: "person.circle", lastMessage: "We leaf to snug on no need. Way own uncommonly travelling now acceptance bed compliment solicitude."),
        Chat(id: 4, title: "Tim", image: "person.circle", lastMessage: "You: Dissimilar admiration so terminated no in contrasted it."),
        Chat(id: 5, title: "Alex", image: "person.circle", lastMessage: "Advantages entreaties mr he apartments do. Limits far yet turned highly repair parish talked six."),
        Chat(id: 6, title: "Ionna", image: "person.circle", lastMessage: "You: Draw fond rank form nor the day eat."),
        Chat(id: 7, title: "Emma", image: "person.circle", lastMessage: "Picture removal detract earnest is by."),
        Chat(id: 8, title: "Travis", image: "person.circle", lastMessage: "I took the Wook to Poland"),
        Chat(id: 9, title: "Noah", image: "person.circle", lastMessage: "Esteems met joy attempt way clothes yet demesne tedious.")
    ]
    
// MARK: Known bugs: navview ignores top safe area

    
    var body: some View {
        NavigationView {
            VStack {
                List(chats) { chat in
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: ChatDetailView(chat: chat)) {
                            EmptyView()
                        }.opacity(0)
                        
                        HStack {
                            Image(systemName: chat.image)
                                .resizable()
                                .frame(width: 55, height: 55)
                            VStack(alignment: .leading) {
                                Text(chat.title)
                                    .padding(5)
                                    .font(.custom("Roboto-Medium", size: 20))
                                    .lineLimit(2)
                                Text(chat.lastMessage)
                                    .padding(5)
                                    .padding(.top, -15)
                                    .font(.custom("Roboto-Regular", size: 15))
                                    .lineLimit(2)
                            }
                            .frame(height: 75)
                        }
                    }
                }
            }
            .padding(-18)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
