//
//  UserModel.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/3/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import Foundation

struct GithubUsers: Codable {
    var items: [User]?
}

struct User: Codable {
    var login: String?
    var avatar_url: String?
    var repos_url: String?
}

struct UserDetails: Codable {
    var avatar_url: String?
    var login: String?
    var bio: String?
    var followers: Int?
    var following: Int?
    var email: String?
    var location: String?
    var created_at: String?
    var public_repos: Int?
}

struct UserRepositoryDetails: Codable {
    var forks_count: Int?
    var stargazers_count: Int?
    var name: String?
    var clone_url: String?
}

