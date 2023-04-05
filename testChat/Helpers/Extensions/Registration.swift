//
//  RegistrationView.swift
//  testChat
//
//  Created by Artour Ilyasov on 06.04.2023.
//

import Foundation

extension RegistrationView {
    func validateName(_ name: String) -> Bool {
        let nameRegEx = "^[a-zA-Z ]*$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: name)
    }
    
    func validateUsername(_ username: String) -> Bool {
        let usernameRegEx = "^[A-Za-z0-9-_]*$"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluate(with: username)
    }
}
