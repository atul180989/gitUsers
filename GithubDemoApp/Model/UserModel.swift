//
//  UserModel.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/3/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import Foundation

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
/* Tapping on a user will bring up a screen that contains the profile details of that user. The view
should contain their avatar image, username, number of followers, number of following,
biography, email, location, join date, and a list of public repositories with a search bar at the top.
Each item of the list view shall contain the name of the repository, the number of stars, and the
number of forks. The search bar will allow the user to search through the user’s repository. The
list view shall not be paginated. Additionally, the search will automatically update upon each
letter entered.*/
