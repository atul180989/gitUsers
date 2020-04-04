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
//    var viewController: UserDetailViewController!
//    var mockObject: MockUserServiceModelProtocol!
//    override func setUp() {
//        mockObject = MockUserServiceModelProtocol()
//        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController
//        viewController.viewModel = UserViewModel()
//        viewController.loadViewIfNeeded()
//    }
//
//    override func tearDown() {
//        mockObject = nil
//    }
//
//    func testRepoObject() {
//        mockObject.fetchRepoDetails(repoURLString: "12323") { (results, error) in
//            XCTAssertNil(error)
//            XCTAssertTrue(results?.first?.name == "Atul")
//            XCTAssertTrue(results?.first?.forks_count == 0)
//        }
//    }
//}
//
//class MockUserServiceModelProtocol : UserViewModelServiceProtocol {
//    func fetchRepoDetails(repoURLString: String, completion: @escaping (([UserRepositoryDetails]?, NetworkError?)) -> Void) {
//        let mockDate: [UserRepositoryDetails] = [UserRepositoryDetails(forks_count: 0, stargazers_count: 0, name: "Atul", clone_url: "https://github.com")]
//        completion((mockDate,nil))
//    }
//    
//    func fetchUserDetails(username: String, completion: @escaping ((UserDetails?, NetworkError?)) -> Void) {
//        let mockData: UserDetails = UserDetails(avatar_url: "", login: "", bio: "", followers: 0, following: 0, email: "", location: "", created_at: "", public_repos: 0)
//        completion((mockData,nil))
//    }
//    
//    func fetchUsers(completion: @escaping (([User], NetworkError?)) -> Void) {
//        let mockData: [User] = [User(login: "Atul", avatar_url: "google.com", repos_url: "github.com")]
//        completion((mockData,nil))
//    }
}
