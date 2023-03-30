import SwiftUI
import PhoneNumberKit
import Combine

struct AuthorizationView: View {

    @State private var selectedCountry = Locale.current.regionCode ?? "RU"
    @State private var phoneNumber = ""
    @State private var showingAlert = false
    @State private var isConfirmationCodePresented = false
    private var phoneNumberKit = PhoneNumberKit() {
        didSet {
            guard let countryCode = phoneNumberKit.countryCode(for: selectedCountry) else { return }
            phoneNumber = "+" + String(countryCode)
        }
    }
    lazy var partialFormatter = PartialFormatter(phoneNumberKit: PhoneNumberKit(), defaultRegion: selectedCountry)

    var body: some View {
        VStack {
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

            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1))
                .padding()
                .font(.custom("Roboto-Light", size: 20))
                .frame(width: 300, height: 75, alignment: .center)

            Button {
                do {
                    let phoneNumber = try phoneNumberKit.parse(self.phoneNumber)
                    let formattedString = phoneNumberKit.format(phoneNumber, toType: .international)
                    self.phoneNumber = formattedString
                    sendAuthCode(self.phoneNumber)
                } catch {
                    showingAlert = true
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


    private func sendAuthCode(_ phoneNumber: String) {
        let url = URL(string: "https://plannerok.ru/api/v1/users/send-auth-code/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = ["phone": phoneNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Invalid data or response")
                return
            }
            if response.statusCode == 201 {
                // успешный запрос, продолжаем
                DispatchQueue.main.async {
                    isConfirmationCodePresented = true
                }
            } else {
                // ошибка при запросе
                print("Status code: \(response.statusCode)")
            }
        }.resume()
    }
}

struct ConfirmationCodeView: View {
    @Binding var isPresented: Bool
    @State private var registrationView = false
    @State private var code: String = "133337"
    @State private var isRegistration = false
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
                            print("auth")
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
                
            }.padding()
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
