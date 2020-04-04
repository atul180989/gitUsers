//
//  ServiceManager.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/3/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case domainError
    case decodingError
    
    var description : String {
        switch self {
        case .decodingError:
            return "Decoding Error"
        case .domainError:
            return "Domain Error"
        }
    }
    
}

class ServiceManager {
    public static let sharedInstance = ServiceManager()
    
    func getApiResult(url:String, completion: @escaping (Result<Data, NetworkError>) -> Void ) {
        guard let newURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: newURL) { (data, response, error) in
            
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                        completion(.failure(.domainError))
                }
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    
    func fetchUsers(completion: @escaping (([User], NetworkError?))-> Void) {
        let urlForUsers = "https://api.github.com/users"
        getApiResult(url: urlForUsers) { (result) in
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
        let userDetailURL = "https://api.github.com/users/\(username)"
        getApiResult(url: userDetailURL) { (result) in
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
        getApiResult(url: repoURLString) { (result) in
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
