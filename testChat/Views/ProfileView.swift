//
//  ProfileView.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import SwiftUI

struct ProfileView: View {
    // Добавляем пример данных пользователя
    let user = User(name: "Ivan Ivanov", city: "Moscow", phoneNumber: "+7 (999) 123-45-67", dateOfBirth: Date(), aboutMe: "I like to do sports and read books.")
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Аватар пользователя
                Image("avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                
                // Никнейм и номер телефона
                VStack(spacing: 10) {
                    Text(user.name)
                        .font(.custom("Roboto-Bold", size: 28))
                    
                    Text(user.phoneNumber)
                        .font(.custom("Roboto-Bold", size: 20))
                        .foregroundColor(.gray)
                }
                
                // Город проживания и дата рождения
                VStack(spacing: 10) {
                    HStack {
                        Text("City:")
                            .font(.custom("Roboto-Medium", size: 20))
                        Text(user.city)
                            .font(.custom("Roboto-Regular", size: 20))
                    }
                    
                    HStack {
                        Text("Date of birth:")
                            .font(.custom("Roboto-Medium", size: 20))
                        Text("\(dateFormatter.string(from: user.dateOfBirth)) (\(user.zodiacSign))")
                            .font(.custom("Roboto-Regular", size: 20))
                    }
                    .padding(.leading, 10)
                }.padding(10)
                
                VStack(spacing: 10) {
                    // О себе
                    Text("About me:")
                        .font(.custom("Roboto-Medium", size: 20))
                    Text(user.aboutMe)
                        .font(.custom("Roboto-Regular", size: 20))
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Профиль")
    }
    
    // Форматтер для отображения даты рождения
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

// Пример модели пользователя
struct User {
    var name: String
    var city: String
    var phoneNumber: String
    var dateOfBirth: Date
    var aboutMe: String
    
    var zodiacSign: String {
        // Реализация определения знака зодиака по дате рождения
        // ...
        return "Aries" // Пример результата
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
