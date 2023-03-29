import SwiftUI
import PhoneNumberKit

struct AuthorizationView: View {

    @State private var selectedCountry = "RU"
    @State private var phoneNumber = "+7"
    let phoneNumberKit = PhoneNumberKit()
    let partialFormatter = PartialFormatter(phoneNumberKit: PhoneNumberKit(), defaultRegion: "RU")

    var body: some View {
        VStack {
            Picker("", selection: $selectedCountry) {
                ForEach(Locale.isoRegionCodes, id: \.self) { countryCode in
                    let country = Locale.current.localizedString(forRegionCode: countryCode)
                    Text(countryFlag(_: countryCode) + " " + (country ?? ""))
                }
            }
            .onChange(of: selectedCountry) { country in
                phoneNumber = "+" + (countryDictionary[country] ?? "")
            }
            TextField("Phone Number", text: $phoneNumber, onEditingChanged: { isEditing in
                if !isEditing {
                    do {
                        let phoneNumber = try phoneNumberKit.parse(phoneNumber)
                        let formattedString = phoneNumberKit.format(phoneNumber, toType: .international)
                        self.phoneNumber = formattedString
                    } catch {
                        // Handle invalid phone number
                    }
                }
            })
            .keyboardType(.phonePad)
        }
    }
}
