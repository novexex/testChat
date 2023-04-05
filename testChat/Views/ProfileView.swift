//
//  ProfileView.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userObject: UserObject
    @State private var isEdit = false
    
    var body: some View {
        ScrollView {
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
                    Text(userObject.user?.name ?? "")
                            .font(.custom("Roboto-Bold", size: 28))
                    Text("@\(userObject.user?.username ?? "")")
                        .font(.custom("Roboto-Regular", size: 20))
                    Text(format(phoneNumber: userObject.user?.phone ?? ""))
                        .font(.custom("Roboto-Bold", size: 20))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 10) {
                    // city
                    if let city = userObject.user?.city, city != "" {
                        HStack {
                            Text("City:")
                                .font(.custom("Roboto-Medium", size: 20))
                            Text(city)
                                .font(.custom("Roboto-Regular", size: 20))
                        }
                    }
                    
                    // birthday
                    if let birthday = userObject.user?.birthday, birthday != getDate(Date()) {
                        HStack {
                            Text("Birthday:")
                                .font(.custom("Roboto-Medium", size: 20))
                            Text(birthday + " " + getZodiacSign(birthday))
                                .font(.custom("Roboto-Regular", size: 20))
                        }
                        .padding(.leading, 10)
                    }
                }.padding(10)
                
                // about me
                if let status = userObject.user?.status, status != "" {
                    VStack(spacing: 10) {
                        Text("About me:")
                            .font(.custom("Roboto-Medium", size: 20))
                        Text(status)
                            .font(.custom("Roboto-Regular", size: 20))
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                Button("Edit") {
                    isEdit = true
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1))
                .sheet(isPresented: $isEdit) {
                    EditProfileView(userObject: userObject, name: userObject.user?.name ?? "", city: userObject.user?.city ?? "", birthday: getDate(userObject.user?.birthday ?? ""), username: userObject.user!.username, status: userObject.user?.status ?? "")
                }
            }
            .padding()
        }
    }
}
