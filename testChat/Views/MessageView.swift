//
//  MessageView.swift
//  testChat
//
//  Created by Artour Ilyasov on 06.04.2023.
//

import SwiftUI

struct MessageView: View {
    let message: String
    let isMyMessage: Bool
    
    var body: some View {
        Text(message)
            .font(.custom("Roboto-Regular", size: 18))
            .padding(10)
            .background(isMyMessage ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2))
            .foregroundColor(isMyMessage ? .white : .black)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: isMyMessage ? .trailing : .leading)
    }
}

