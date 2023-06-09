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
    let username: String
    var birthday: String?
    var city: String?
    let vk: String?
    let instagram: String?
    var status: String?
    let avatar: String?
    let id: Int
    let last: Date?
    let online: Bool
    let created: Date?
    let phone: String
    let completedTask: Int?
    let avatars: Avatars?

    enum CodingKeys: String, CodingKey {
        case name, username, birthday, city, vk, instagram, status, avatar, id, last, online, created, phone
        case completedTask = "completed_task"
        case avatars
    }
}

struct Avatars: Codable {
    let avatar, bigAvatar, miniAvatar: String
}
