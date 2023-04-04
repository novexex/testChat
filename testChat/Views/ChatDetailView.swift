//
//  ChatDetailView.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import SwiftUI

struct ChatDetailView: View {
    let chat: Chat
    @State private var entryMessage = ""
    private let messages = [
        "Привет!",
        "Как дела?",
        "У меня все хорошо, а у тебя?",
        "У меня тоже все отлично!",
        "Как проходит день?",
        "День проходит нормально, но я устал.",
        "Понимаю. Ты что-нибудь интересное делал сегодня?",
        "Да, я был на прогулке в парке. Было очень красиво.",
        "Звучит здорово! Я тоже люблю гулять в парке.",
        "Давай в следующий раз пойдем вместе!",
    ]
    
    var body: some View {
        VStack {
            
            Spacer()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(messages.enumerated()), id: \.1) { index, message in
                        if index % 2 == 0 {
                            MessageView(message: message, isMyMessage: true)
                        } else {
                            MessageView(message: message, isMyMessage: false)
                        }
                    }
                }
            }
            .padding()
            

            HStack {
                TextField("Enter your message", text: $entryMessage)
                    .frame(height: 18)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1))
                    .padding(10)
                    .padding(.trailing, -10)
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .padding(.trailing, 10)
            }
            .frame(height: 4)
            .padding(.bottom, 30)
            .background(Color.clear)
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView(chat: Chat(id: 10, title: "Title", image: "", lastMessage: "Last message"))
    }
}

struct MessageView: View {
    let message: String
    let isMyMessage: Bool

    var body: some View {
        Text(message)
            .padding(10)
            .background(isMyMessage ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2))
            .foregroundColor(isMyMessage ? .white : .black)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: isMyMessage ? .trailing : .leading)
    }
}
