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
    @State private var messages = [
        "Hello!",
        "How are you?",
        "I'm fine, and you?",
        "I'm fine too!",
        "How your day is going?",
        "The day is going fine, but I'm tired.",
        "I see. Did you do anything interesting today?",
        "Yes, I was on a walk in the park. It was very beautiful.",
        "That sounds great! I love walking in the park, too.",
        "Let's go together next time!",
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
                Button {
                    messages.append(entryMessage)
                    entryMessage = ""
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .padding(.trailing, 10)
                }
            }
            .frame(height: 4)
            .padding(.bottom, 30)
            .background(Color.clear)
        }
    }
}
