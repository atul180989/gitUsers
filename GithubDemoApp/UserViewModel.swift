//
//  UserViewModel.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/4/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import Foundation

class UserViewModel: UserViewModelServiceProtocol {
    
    func fetchUsers(completion: @escaping (([User], NetworkError?))-> Void) {
        ServiceManager.sharedInstance.getApiResult(url: baseAPIURL) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = try? JSONDecoder().decode([User].self, from: data) {
                    completion((jsonData, nil))
                } else {
                    completion(([],.decodingError))
                }
            case .failure(let error):
                completion(([], error))
            }
        }
    }

    func fetchUserDetails(username: String, completion: @escaping ((UserDetails?, NetworkError?))-> Void) {
        let userDetailURL = "\(baseAPIURL)/\(username)"
        ServiceManager.sharedInstance.getApiResult(url: userDetailURL) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = try? JSONDecoder().decode(UserDetails.self, from: data) {
                    completion((jsonData, nil))
                } else {
                    completion((nil,.decodingError))
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
                    completion((nil,.decodingError))
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
    func fetchUsers(completion: @escaping (([User], NetworkError?))-> Void)
}
