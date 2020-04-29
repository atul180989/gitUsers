//
//  UserDetailViewController.swift
//  GithubDemoApp
//
//  Created by Atul Bhaisare on 4/3/20.
//  Copyright © 2020 Atul Bhaisare. All rights reserved.
//

import UIKit
import SDWebImage

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
}

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    var userDetails: UserDetails?
    var viewModel: UserViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        self.userImageView.layer.cornerRadius = 10
        self.userImageView.layer.masksToBounds = true
        updateUserDetails()
        fetchUserRepoDetails()        
    }
    
    // Display User Details
    private func updateUserDetails() {
        
        viewModel.fetchUserDetails(username: userName!) { (userDetails, error) in
                        if error != nil {
                            
                        } else {
                            self.userDetails = userDetails
                            DispatchQueue.main.async {
                                self.usernameLabel.text = userDetails?.login
                                self.bioLabel.text = userDetails?.bio ?? notAvailable
                                self.locationLabel.text = userDetails?.location ?? notAvailable
                                self.followersLabel.text = "\(userDetails?.followers ?? 0)"
                                self.followingLabel.text = "\(userDetails?.following ?? 0)"
                                self.emailLabel.text = userDetails?.email ?? notAvailable
                                self.joinedLabel.text = self.formatDate(date: (userDetails?.created_at) ?? "") ?? notAvailable

                            }
                            DispatchQueue.global(qos: .background).async {
                                guard let imageURL = self.userDetails?.avatar_url, let url = URL(string:(imageURL)), let data = try? Data(contentsOf: url), let image: UIImage = UIImage(data: data) else { return }
                                DispatchQueue.main.async {
                                    self.userImageView.image = image
                                }
                            }
                        }
                    }
    }
    
    // Fetch Repo Details
    private func fetchUserRepoDetails() {
        self.activityIndicator.startAnimating()
        viewModel.fetchRepoDetails(repoURLString: reposURL!) { (result , error) in
            if error != nil {
                // Show Alert View
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(message: error?.description)
                }
            } else {
                if let repoArray = result {
                    self.filteredRepoArray = repoArray
                    self.repoArray = repoArray
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.repositoryTableView.reloadData()
                }
            }
        }
    }
    
    // Date Formattter
    private func formatDate(date : String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let newDate = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "MMM dd,yyyy"
        return dateFormatter.string(from: newDate)
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
        if activityIndicator.isAnimating {
            return 1
        } else {
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
                noDataLabel.text          = noData
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
            return numOfSections
        }
    }
}

//MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let clone_url = filteredRepoArray[indexPath.row].clone_url , let url = URL(string: clone_url) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
