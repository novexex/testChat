//
//  ConfirmationCodeView.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import SwiftUI

struct ConfirmationCodeView: View {
    let phoneNumber: String
    
    @State private var code = "133337"
    @State private var isRegistration = false
    @State private var isAuth = false
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Enter confirmation code")
                    .font(.custom("Roboto-Light", size: 25))
                    .padding()
                
                TextField("Code", text: $code)
                    .padding()
                    .keyboardType(.phonePad)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1))
                    .font(.custom("Roboto-Light", size: 20))
                    .frame(width: 200, height: 50)
                    .padding(.bottom, 10)
                
                Button(action: {
                    if code != "133337" {
                        showingAlert = true
                    } else {
                        NetworkService.checkAuthCode(phoneNumber, code) { response in
                            if response {
                                isAuth = true
                            } else {
                                isRegistration = true
                            }
                        }
                    }
                    
                }) {
                    Text("Verify")
                        .padding()
                        .frame(width: 200, height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"),
                          message: Text("Incorrect confirmation code"),
                          dismissButton: .default(Text("OK")))
                }
                .fullScreenCover(isPresented: $isRegistration) {
                    RegistrationView(phoneNumber: phoneNumber)
                }
                .fullScreenCover(isPresented: $isAuth) {
                    MainView()
                }
            }
            .padding()
        }
    }
}
