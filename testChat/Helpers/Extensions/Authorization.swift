//
//  Extensions.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

extension AuthorizationView {
    func countryFlag(_ countryCode: String) -> String {
        let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        let flag = countryCode
            .uppercased()
            .unicodeScalars
            .compactMap({ UnicodeScalar(flagBase + $0.value)?.description })
            .joined()
        return flag
    }
}
