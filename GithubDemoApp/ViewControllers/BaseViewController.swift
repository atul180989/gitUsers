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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
        userNameLabel.text = nil
        repoCountLabel.text = nil
    }
    
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
    var page = 0
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersTable: UITableView!
    lazy var filteredArray :[User] = []
    lazy var userdetailsArray: [UserDetails] = []
    lazy var filteredUserDetailsArray: [UserDetails] = []
    var viewModel: UserViewModel!
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        self.title = baseVCTitle
        searchBar.placeholder = searchBarPlaceHolder
    }
    
    private func fetchUsers(_ username: String, _ page: Int) {
        viewModel.fetchUsers(username: username, page: page) { (users, error) in
            if error != nil {
                // Show Alert View
                DispatchQueue.main.async {
                    self.showAlert(message: error?.description)
                }
            } else {
                self.filteredArray = users ?? []
                DispatchQueue.main.async {
                    self.usersTable.reloadData()
                }
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension BaseViewController: UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            page = 0
            self.filteredArray.removeAll()
        }
        self.searchText = searchText.replacingOccurrences(of: " ", with: "")
        fetchUsers(self.searchText, 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
        if filteredArray.count > 0 {
            cell.userNameLabel.text = filteredArray[indexPath.row].login
            let user = filteredArray[indexPath.row]
            let userrepourl = user.repos_url!
            UserViewModel().fetchRepoDetails(repoURLString: userrepourl) { (result, error) in
                DispatchQueue.main.async {
                    let repo = result ?? []
                    cell.repoCountLabel.text = "\(repo.count)"
                }
            }
            guard let imageURL = self.filteredArray[indexPath.row].avatar_url, let url = URL(string:(imageURL)) else { return UITableViewCell()  }
            cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar.jpg"))
        }
        return cell
    }
}
//MARK: - UITableViewDelegate
extension BaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController else { return }
        detailViewController.reposURL = filteredArray[indexPath.row].repos_url
        detailViewController.userName = filteredArray[indexPath.row].login
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            page += 1
            fetchUsers(searchText, page)
        }
    }
}

extension UIViewController {
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ok, style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
