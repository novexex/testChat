//
//  ProfileDataEntity.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import Foundation

// MARK: - ProfileData
struct ProfileData: Codable {
    let profileData: UserProfile

    enum CodingKeys: String, CodingKey {
        case profileData = "profile_data"
    }
}

// MARK: - ProfileDataClass
struct UserProfile: Codable {
    let name: String
    let username: String
    let birthday: String?
    let city: String?
    let vk: String?
    let instagram: String?
    let status: String?
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

// MARK: - Avatars
struct Avatars: Codable {
    let avatar, bigAvatar, miniAvatar: String
}
