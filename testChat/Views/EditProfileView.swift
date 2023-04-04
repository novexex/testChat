//
//  EditProfileView.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String
    @State var city: String
    @State var birthday: Date
    @State var username: String
    @State var aboutMe: String
    @State private var selectedImage: UIImage?
    
    @State private var showImagePicker = false
    @State private var nameChanged = false
    @State private var cityChanged = false
    @State private var birthdayChanged = false
    @State private var aboutMeChanged = false
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $name)
                    .onChange(of: name) { _ in
                        nameChanged = true
                    }
                TextField("City", text: $city)
                    .onChange(of: city) { _ in
                        cityChanged = true
                    }
                DatePicker("Date of birth", selection: $birthday, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .foregroundColor(.black)
                    .onChange(of: birthday) { _ in
                        birthdayChanged = true
                    }
                TextField("About me", text: $aboutMe)
                    .onChange(of: aboutMe) { _ in
                        aboutMeChanged = true
                    }
            }
            
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
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: self.$selectedImage)
                }
            }
            
            
            Section {
                Button(action: {
                    if let selectedImage, let avatarData = selectedImage.jpegData(compressionQuality: 0.1) {

                        let avatarBase64 = avatarData.base64EncodedString()
                        let avatar = Avatar(filename: "avatar.jpeg", base_64: avatarBase64)
                        
                        let user = UserUpdateRequest(name: name,
                                                     username: username,
                                                     birthday: birthday,
                                                     city: city,
                                                     vk: nil,
                                                     instagram: nil,
                                                     status: aboutMe,
                                                     avatar: avatar)
                        NetworkService.putProfileView(user: user)
                    } else {
                        let user = UserUpdateRequest(name: name,
                                                     username: username,
                                                     birthday: birthday,
                                                     city: city,
                                                     vk: nil,
                                                     instagram: nil,
                                                     status: aboutMe,
                                                     avatar: nil)
                        NetworkService.putProfileView(user: user)
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Save Changes")
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.parent.selectedImage = selectedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView(name: "", city: "", birthday: Date())
//    }
//}
