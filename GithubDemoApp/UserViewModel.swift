//
//  UserViewModel.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/4/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import Foundation

class UserViewModel: UserViewModelServiceProtocol {
    var users: [User] = []
    func fetchUsers(username: String, page: Int = 0, completion: @escaping (([User]?, NetworkError?))-> Void) {
        let url =  baseAPIURL + "/search/users?q=" + username + "&page=\(page)"
        ServiceManager.sharedInstance.getApiResult(url: url) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = try? JSONDecoder().decode(GithubUsers.self, from: data) {
                    if page == 0 {
                        self.users = jsonData.items ?? []
                        completion((self.users, nil))
                    } else {
                        self.users.append(contentsOf: jsonData.items ?? [])
                        completion((self.users, nil))
                    }
                } else {
                    completion((nil,.limitExceedingError))
                }
            case .failure(let error):
                completion((nil, error))
            }
        }
    }
    
    func fetchUserDetails(username: String, completion: @escaping ((UserDetails?, NetworkError?))-> Void) {
        let userDetailURL = "\(baseAPIURL)/users/\(username)"
        ServiceManager.sharedInstance.getApiResult(url: userDetailURL) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = try? JSONDecoder().decode(UserDetails.self, from: data) {
                    completion((jsonData, nil))
                } else {
                    completion((nil,.limitExceedingError))
                }
            case .failure(let error):
                completion((nil, error))
            }
        }
    }
    
    func fetchRepoDetails(repoURLString: String, completion: @escaping (([UserRepositoryDetails]?, NetworkError?))-> Void) {
        ServiceManager.sharedInstance.getApiResult(url: repoURLString) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = try? JSONDecoder().decode([UserRepositoryDetails].self, from: data) {
                    completion((jsonData, nil))
                } else {
                    completion((nil,.limitExceedingError))
                }
            case .failure(let error):
                completion((nil, error))
            }
        }
    }
}

protocol UserViewModelServiceProtocol : class {
    func fetchRepoDetails(repoURLString: String, completion: @escaping (([UserRepositoryDetails]?, NetworkError?))-> Void)
    func fetchUserDetails(username: String, completion: @escaping ((UserDetails?, NetworkError?))-> Void)
    func fetchUsers(username: String, page: Int, completion: @escaping (([User]?, NetworkError?))-> Void)
}
 
