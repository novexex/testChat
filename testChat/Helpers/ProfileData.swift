//
//  ProfileData.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import Foundation

struct ProfileData: Codable {
    let profileData: UserProfile

    enum CodingKeys: String, CodingKey {
        case profileData = "profile_data"
    }
}

struct UserProfile: Codable {
    var name: String
    var username: String
    var birthday: String?
    var city: String?
    var vk: String?
    var instagram: String?
    var status: String?
    var avatar: String?
    var id: Int
    var last: Date?
    var online: Bool
    var created: Date?
    var phone: String
    var completedTask: Int?
    var avatars: Avatars?

    enum CodingKeys: String, CodingKey {
        case name, username, birthday, city, vk, instagram, status, avatar, id, last, online, created, phone
        case completedTask = "completed_task"
        case avatars
    }
}

struct Avatars: Codable {
    let avatar, bigAvatar, miniAvatar: String
}
