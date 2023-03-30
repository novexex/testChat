//
//  ProfileView.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import SwiftUI

struct ProfileView: View {
    //    let user = User(name: "Ivan Ivanov", city: "Moscow", phone: "+7 (999) 123-45-67", dateOfBirth: Date(), aboutMe: "I like to do sports and read books.")
    
    let user: UserProfile?
    
    var body: some View {
        ScrollView {
            if let user {
                VStack(spacing: 20) {
                    // Аватар пользователя
                    Image("avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    
                    // Имя, никнейм и номер телефона
                    VStack(spacing: 10) {
                        Text(user.name)
                            .font(.custom("Roboto-Bold", size: 28))
                        Text(user.username)
                            .font(.custom("Roboto-Bold", size: 28))
                        Text(user.phone)
                            .font(.custom("Roboto-Bold", size: 20))
                            .foregroundColor(.gray)
                    }
                    
                    // Город проживания и дата рождения
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
                    
                    //                VStack(spacing: 10) {
                    //                    // О себе
                    //                    Text("About me:")
                    //                        .font(.custom("Roboto-Medium", size: 20))
                    //                    Text(user.aboutMe)
                    //                        .font(.custom("Roboto-Regular", size: 20))
                    //                        .multilineTextAlignment(.center)
                    //                }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitle("Профиль")
    }
}

