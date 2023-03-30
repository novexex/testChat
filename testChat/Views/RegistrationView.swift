//
//  Regis.swift
//  testChat
//
//  Created by Artour Ilyasov on 29.03.2023.
//

import SwiftUI

struct RegistrationView: View {
    
    var phoneNumber: String
    @State private var text = ""
    @State private var username = ""
    @State private var name = ""
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .username
    @State private var isAuth = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(phoneNumber)
                        .foregroundColor(.black)
                        .font(.custom("Roboto-Light", size: 18))
                        .padding()
                        .padding()
                        .padding(.bottom, -25)
                }
                
                TextField("", text: $text)
                    .font(.custom("Roboto-Light", size: 18))
                    .accentColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1))
                    .padding()
                    .padding(.bottom, -25)
                    .disabled(true)
            }
            
            TextField("Enter your username", text: $username)
                .font(.custom("Roboto-Light", size: 18))
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1))
                .padding()
            
            TextField("Enter your name", text: $name)
                .font(.custom("Roboto-Light", size: 18))
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1))
                .padding()
                .padding(.top, -25)
            
            Button("Register") {
                var validation = 0
                
                //username validation
                if validateUsername(username) && !username.isEmpty {
                    validation += 1
                } else {
                    activeAlert = .username
                    username = ""
                }
                
                //name validation
                if validateName(name) && !name.isEmpty {
                    validation += 1
                } else {
                    activeAlert = .name
                    name = ""
                }
                
                if validation == 2 {
                    registerUser(phoneNumber, name, username) { response in
                        if response == 400 {
                            activeAlert = .usernameExists
                            showAlert = true
                            username = ""
                        } else if response == 422 {
                            activeAlert = .username
                            showAlert = true
                            username = ""
                        } else if response == 201 {
                            isAuth = true
                        }
                    }
                } else if validation == 0 {
                    activeAlert = .nameAndUsername
                }
                
                if validation != 2 {
                    showAlert = true
                }
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1))
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .nameAndUsername:
                    return Alert(title: Text("Error"),
                                 message: Text("Incorrect name and username"),
                                 dismissButton: .default(Text("OK")))
                case .username:
                    return Alert(title: Text("Error"),
                                 message: Text("Incorrect username"),
                                 dismissButton: .default(Text("OK")))
                case .name:
                    return Alert(title: Text("Error"),
                                 message: Text("Incorrect name"),
                                 dismissButton: .default(Text("OK")))
                case .usernameExists:
                    return Alert(title: Text("Error"),
                                 message: Text("This username already exists"),
                                 dismissButton: .default(Text("OK")))
                }
            }
            .fullScreenCover(isPresented: $isAuth) {
                MainView()
            }
        }
        .padding()
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(phoneNumber: "+79053768859")
    }
}

