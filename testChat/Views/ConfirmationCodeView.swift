//
//  ConfirmationCodeView.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import SwiftUI

struct ConfirmationCodeView: View {
    @State private var registrationView = false
    @State private var code: String = "133337"
    @State private var isRegistration = false
    @State private var isAuth = false
    var phoneNumber: String
    
    var body: some View {
        ZStack {
            Color(.white).ignoresSafeArea()
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
                    if code.count != 6 || !code.allSatisfy({ $0.isNumber }) {
                        return
                    }
                    
                    NetworkService.checkAuthCode(phoneNumber, code) { response in
                        if response {
                            isAuth = true
                        } else {
                            isRegistration = true
                        }
                    }
                    
                }) {
                    Text("Verify")
                        .padding()
                        .frame(width: 200, height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1))
                }
                .fullScreenCover(isPresented: $isRegistration) {
                    RegistrationView(phoneNumber: phoneNumber)
                }
                .fullScreenCover(isPresented: $isAuth) {
                    MainView()
                }
                
            }.padding()
        }
    }
}
