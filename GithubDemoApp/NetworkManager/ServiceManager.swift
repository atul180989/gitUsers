//
//  ServiceManager.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/3/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import Foundation
import UIKit

let baseAPIURL = "https://api.github.com/users"

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
    private init () {}
    
    func getApiResult(url:String, completion: @escaping (Result<Data, NetworkError>) -> Void ) {
        guard let newURL = URL(string: url) else { return }
        let request = ServiceManager.sharedInstance.getURLRequest(url: newURL)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.domainError))
                }
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    func getURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("token 37c5d41c7669241e5b422f5687d611c021cb1ac8", forHTTPHeaderField: "Authorization")
        return request
    }
}
