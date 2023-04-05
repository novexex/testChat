//
//  EditProfileView.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var userObject: NetworkObject
    @State var name: String
    @State var city: String
    @State var birthday: Date
    @State var username: String
    @State var status: String
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $name)
                    .font(.custom("Roboto-Light", size: 18))
                TextField("City", text: $city)
                    .font(.custom("Roboto-Light", size: 18))
                DatePicker("Date of birth", selection: $birthday, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .foregroundColor(.black)
                    .font(.custom("Roboto-Regular", size: 17))
                TextField("About me", text: $status)
                    .font(.custom("Roboto-Light", size: 18))
            }
            .font(.custom("Roboto-Regular", size: 14))
            
            Section(header: Text("Avatar")) {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                }
                
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Change Avatar")
                        .font(.custom("Roboto-Regular", size: 17))
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: self.$selectedImage)
                }
            }
            .font(.custom("Roboto-Regular", size: 14))
            
            Section {
                Button(action: {
                    let avatarData = selectedImage?.jpegData(compressionQuality: 0.1)
                    let avatarBase64 = avatarData?.base64EncodedString()
                    let avatar = Avatar(filename: "avatar.jpeg", base_64: avatarBase64 ?? "")
                    
                    let user = UserUpdateRequest(name: name,
                                                 username: username,
                                                 birthday: getDate(birthday),
                                                 city: city,
                                                 vk: nil,
                                                 instagram: nil,
                                                 status: status,
                                                 avatar: avatar.base_64 == "" ? nil : avatar)
                    
                    NetworkService.putProfileView(user: user)
                    
                    // local fetch
                    userObject.user?.name = name
                    userObject.user?.city = city
                    userObject.user?.birthday = getDate(birthday)
                    userObject.user?.status = status
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .font(.custom("Roboto-Regular", size: 17))
                        .onReceive(userObject.$user) { user in
                            name = user?.name ?? ""
                            city = user?.city ?? ""
                            status = user?.status ?? ""
                            if let birthday = user?.birthday {
                                self.birthday = getDate(birthday)
                            }
                        }
                }
            }
        }
    }
}


