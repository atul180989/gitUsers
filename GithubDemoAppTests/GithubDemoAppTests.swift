//
//  GithubDemoAppTests.swift
//  GithubDemoAppTests
//
//  Created by Atul Bhaisare on 4/3/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import XCTest
@testable import GithubDemoApp

class GithubDemoAppTests: XCTestCase {
    var mockObject: MockUserServiceModelProtocol!
    override func setUp() {
        mockObject = MockUserServiceModelProtocol()
    }
    
    override func tearDown() {
        mockObject = nil
    }
    
    func testRepoObject() {
        mockObject.fetchRepoDetails(repoURLString: "https://github.com") { (results, error) in
            XCTAssertNil(error)
            XCTAssertTrue(results?.first?.name == "Atul")
            XCTAssertTrue(results?.first?.forks_count == 0)
        }
    }
    
    func testUserObject() {
        mockObject.fetchUsers(username: "0", page: 0) { (users, error) in
            XCTAssertNil(error)
            XCTAssertTrue(users?.first?.login == "Atul")
            XCTAssertTrue(users?.first?.avatar_url == "google.com")
        }
        
    }
    
    func testUserDetailsObject() {
        mockObject.fetchUserDetails(username: "Atul") { (result, error) in
            XCTAssertNil(error)
            XCTAssertTrue(result?.login == "Mojombo")
            XCTAssertTrue(result?.public_repos == 10)
        }
    }
}

class MockUserServiceModelProtocol : UserViewModelServiceProtocol {
    func fetchUsers(username: String, page: Int, completion: @escaping (([User]?, NetworkError?)) -> Void) {
        let mockData: [User] = [User(login: "Atul", avatar_url: "google.com", repos_url: "github.com")]
        completion((mockData,nil))
    }
    
    func fetchRepoDetails(repoURLString: String, completion: @escaping (([UserRepositoryDetails]?, NetworkError?)) -> Void) {
        let mockDate: [UserRepositoryDetails] = [UserRepositoryDetails(forks_count: 0, stargazers_count: 0, name: "Atul", clone_url: "https://github.com")]
        completion((mockDate,nil))
    }
    
    func fetchUserDetails(username: String, completion: @escaping ((UserDetails?, NetworkError?)) -> Void) {
        let mockData: UserDetails = UserDetails(avatar_url: "", login: "Mojombo", bio: "", followers: 20, following: 0, email: "", location: "", created_at: "", public_repos: 10)
        completion((mockData,nil))
    }
}
