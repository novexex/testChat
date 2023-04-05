import SwiftUI
import PhoneNumberKit
import Combine

struct AuthorizationView: View {
    @State private var selectedCountry = Locale.current.regionCode ?? "US"
    @State private var phoneNumber = ""
    @State private var showingAlert = false
    @State var presentingConfirmationCodeView = false
    
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
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1))
            
            // phone number entry field
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
                let countryCode = phoneNumber
                let formattedPhoneNumber = format(phoneNumber)
                if formattedPhoneNumber.isEmpty {
                    showingAlert = true
                    phoneNumber = countryCode
                } else {
                    sendAuthCode(formattedPhoneNumber)
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
        .sheet(isPresented: $presentingConfirmationCodeView) {
            ConfirmationCodeView(phoneNumber: phoneNumber)
        }
    }
}
