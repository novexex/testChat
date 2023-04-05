//
//  UserUpdateRequest.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

struct UserUpdateRequest: Encodable {
    let name: String
    let username: String
    let birthday: String?
    let city: String?
    let vk: String?
    let instagram: String?
    let status: String?
    let avatar: Avatar?
}

struct Avatar: Encodable {
    let filename: String
    let base_64: String
}
