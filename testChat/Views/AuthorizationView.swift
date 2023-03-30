import SwiftUI
import PhoneNumberKit
import Combine

struct AuthorizationView: View {
    
    @State private var selectedCountry = Locale.current.regionCode ?? "RU"
    @State private var phoneNumber = ""
    @State private var showingAlert = false
    @State var isConfirmationCodePresented = false
    private let phoneNumberKit = PhoneNumberKit()
    lazy var partialFormatter = PartialFormatter(phoneNumberKit: PhoneNumberKit(), defaultRegion: selectedCountry)
    
    var body: some View {
        VStack {
            // list of countrys with flags
            Picker("", selection: $selectedCountry) {
                ForEach(Locale.isoRegionCodes, id: \.self) { countryCode in
                    let country = Locale.current.localizedString(forRegionCode: countryCode)
                    Text(countryFlag(_: countryCode) + " " + (country ?? ""))
                }
            }
            .onChange(of: selectedCountry) { country in
                guard let countryCode = phoneNumberKit.countryCode(for: country) else { return }
                phoneNumber = "+" + String(countryCode)
            }
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1))
            
            // field where we enter phone number
            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1))
                .padding()
                .font(.custom("Roboto-Light", size: 20))
                .frame(width: 300, height: 75, alignment: .center)
            
            // log in button
            Button {
                phoneNumber = format(phoneNumber: self.phoneNumber)
                if phoneNumber.isEmpty {
                    showingAlert = true
                } else {
                    self.sendAuthCode(self.phoneNumber)
                }
            } label: {
                Text("Log in")
                    .font(.custom("Roboto-Light", size: 20))
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"),
                      message: Text("Incorrect phone number"),
                      dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .onAppear {
            guard let countryCode = phoneNumberKit.countryCode(for: selectedCountry) else { return }
            phoneNumber = "+" + String(countryCode)
        }
        .sheet(isPresented: $isConfirmationCodePresented) {
            ConfirmationCodeView(isPresented: $isConfirmationCodePresented, phoneNumber: phoneNumber)
        }
    }
}

struct ConfirmationCodeView: View {
    @Binding var isPresented: Bool
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
                    
                    checkAuthCode(phoneNumber, code) { response in
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

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
