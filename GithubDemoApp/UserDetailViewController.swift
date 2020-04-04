//
//  UserDetailViewController.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/3/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import UIKit
import SafariServices
class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
}

class UserDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var repositoryTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredRepoArray: [UserRepositoryDetails] = []
    var repoArray: [UserRepositoryDetails] = []
    var reposURL: String?
    var userName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userID = userName else { return }
        ServiceManager().fetchUserDetails(username: userID) { (result , error) in
            
            if error != nil {
                print(error?.description ?? "")
            } else {
                DispatchQueue.global(qos: .background).async {
                    guard let imageURL = result?.avatar_url, let url = URL(string:(imageURL)), let data = try? Data(contentsOf: url), let image: UIImage = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.userImageView.image = image
                    }
                }
    
                DispatchQueue.main.async {
                    self.usernameLabel.text = result?.login
                    self.bioLabel.text = result?.bio ?? "Not Available"
                    self.locationLabel.text = result?.location
                    self.followersLabel.text = "\(result?.followers ?? 0)"
                    self.followingLabel.text = "\(result?.following ?? 0)"
                    self.emailLabel.text = result?.email ?? "Not Available"
                    self.joinedLabel.text = result?.created_at ?? "Not Available"
                }
            }
        }
        
        ServiceManager().fetchRepoDetails(repoURLString: reposURL!) { (result , error) in
            if error != nil {
                print(error?.description ?? "")
            } else {
                guard let repoArray = result else { return }
                self.filteredRepoArray = repoArray
                self.repoArray = repoArray
                DispatchQueue.main.async {
                    self.repositoryTableView.reloadData()
                }
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension UserDetailViewController: UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            filteredRepoArray = repoArray.filter({ ($0.name ?? "").hasPrefix(searchText.lowercased())})
        } else {
            filteredRepoArray = repoArray
        }
        print(filteredRepoArray.count)
        repositoryTableView.reloadData()
    }
}
//MARK: - UITableViewDataSource
extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as? RepositoryCell else {
            return UITableViewCell()
        }
        cell.repoNameLabel.text = filteredRepoArray[indexPath.row].name
        cell.starsCountLabel.text = "\(filteredRepoArray[indexPath.row].stargazers_count ?? 0)"
        cell.forksCountLabel.text = "\(filteredRepoArray[indexPath.row].forks_count ?? 0)"
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if filteredRepoArray.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
}
//MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let clone_url = filteredRepoArray[indexPath.row].clone_url , let url = URL(string: clone_url) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
