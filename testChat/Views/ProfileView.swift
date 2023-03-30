//
//  ProfileView.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import SwiftUI

struct ProfileView: View {
    let user: UserProfile?
    
    var body: some View {
        ScrollView {
            if let user {
                VStack(spacing: 20) {
                    // avatar
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    
                    // name, nickname and phone number
                    VStack(spacing: 10) {
                        Text(user.name)
                            .font(.custom("Roboto-Bold", size: 28))
                        Text("@\(user.username)")
                            .font(.custom("Roboto-Regular", size: 20))
                        Text(format(phoneNumber: user.phone))
                            .font(.custom("Roboto-Bold", size: 20))
                            .foregroundColor(.gray)
                    }
                    
                    // city and birthday
                    VStack(spacing: 10) {
                        if let city = user.city {
                            HStack {
                                Text("City:")
                                    .font(.custom("Roboto-Medium", size: 20))
                                Text(city)
                                    .font(.custom("Roboto-Regular", size: 20))
                            }
                        }
                        if let birthday = user.birthday {
                            HStack {
                                Text("Date of birth:")
                                    .font(.custom("Roboto-Medium", size: 20))
                                Text(birthday)
                                    .font(.custom("Roboto-Regular", size: 20))
                            }
                            .padding(.leading, 10)
                        }
                    }.padding(10)
                    Spacer()
                }
                .padding()
            }
        }
    }
}
