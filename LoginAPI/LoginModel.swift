//
//  LoginModel.swift
//  RxAlamofire
//
//  Created by user on 2023/01/23.
//

import Foundation
// MARK: - LoginInfo
struct LoginInfo: Codable {
    let data: DataClass?
    let message: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let user: User?
    let token: Token?
}

// MARK: - Token
struct Token: Codable {
    let tokenType: String?
    let expiresIn: Int?
    let accessToken, refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, email: String?
    let postCount: Int?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case postCount = "post_count"
        case avatar
    }
}
