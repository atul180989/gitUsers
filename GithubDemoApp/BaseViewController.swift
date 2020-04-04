//
//  BaseViewController.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/3/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var repoCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    func configureCell() {
        self.userImageView.layer.cornerRadius = 10
        self.userImageView.layer.masksToBounds = true
    }
}

class BaseViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersTable: UITableView!
    var filteredArray :[User] = []
    var usersArray: [User] = []
    var userdetailsArray: [UserDetails] = []
    let imageCache = NSCache<NSString, UIImage>()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        self.title = "Git Users"
        searchBar.placeholder = "Search User"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredArray = usersArray
        usersTable.reloadData()
        searchBar.searchTextField.text = ""
    }
    
    private func fetchUsers() {
            ServiceManager().fetchUsers { (users, error) in
            self.usersArray = users
            self.filteredArray = users
            self.fetchAllUserDetails()
        }
    }
    
    private func fetchAllUserDetails() {
        let myGroup = DispatchGroup()
        for user in filteredArray {
            myGroup.enter()
            guard let userName = user.login else { return }
            ServiceManager.sharedInstance.fetchUserDetails(username: userName) { (userDetails, Error) in
                guard let userInfo = userDetails else { return }
                self.userdetailsArray.append(userInfo)
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) {
            self.usersTable.reloadData()
        }
    }
}

//MARK: - UISearchBarDelegate
extension BaseViewController: UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            filteredArray = usersArray.filter({ $0.login!.hasPrefix(searchText.lowercased())})
        } else {
            filteredArray = usersArray
        }
        print(filteredArray)
        usersTable.reloadData()
    }
}
//MARK: - UITableViewDataSource
extension BaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gitCell") as? UserCell else {
            return UITableViewCell()
        }
        cell.userNameLabel.text = filteredArray[indexPath.row].login
        if userdetailsArray.count > 0 {
            cell.repoCountLabel.text = "\(userdetailsArray[indexPath.row].public_repos ?? 0)"
        }
        if let cachedImage = imageCache.object(forKey: NSString(string: (self.filteredArray[indexPath.row].login!))) {
              cell.userImageView.image = cachedImage
        } else {
              DispatchQueue.global(qos: .background).async {
                  guard let imageURL = self.filteredArray[indexPath.row].avatar_url, let url = URL(string:(imageURL)), let data = try? Data(contentsOf: url), let image: UIImage = UIImage(data: data) else { return }
                  self.imageCache.setObject(image, forKey: NSString(string: (self.filteredArray[indexPath.row].login!)))
                  DispatchQueue.main.async {
                       cell.userImageView.image = image
                  }
              }
        }
        DispatchQueue.global(qos: .background).async {
            guard let imageURL = self.filteredArray[indexPath.row].avatar_url, let url = URL(string:(imageURL)), let data = try? Data(contentsOf: url), let image: UIImage = UIImage(data: data) else { return }
            self.imageCache.setObject(image, forKey: NSString(string: (self.filteredArray[indexPath.row].login!)))
            DispatchQueue.main.async {
                 cell.userImageView.image = image
            }
        }
        return cell
    }
}
//MARK: - UITableViewDelegate
extension BaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UserDetailViewController") as? UserDetailViewController else { return }
        detailViewController.reposURL = filteredArray[indexPath.row].repos_url
        detailViewController.userName = filteredArray[indexPath.row].login
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
