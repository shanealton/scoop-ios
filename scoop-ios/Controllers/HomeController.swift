//
//  HomeController.swift
//  scoop-ios
//
//  Created by Shane Alton on 10/12/21.
//

import LBTATools
import WebKit
import Alamofire

struct Post: Decodable {
    let id: String
    let text: String
    let createdAt: Int
    let user: User
}

struct User: Decodable {
    let id: String
    let name: String
}

class HomeController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = .init(title: "Fetch Posts", style: .plain, target: self, action: #selector(fetchPosts))
        
        navigationItem.leftBarButtonItem = .init(title: "Login", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    @objc fileprivate func handleLogin() {
        print("Show login and sign up pages")
        let navController = UINavigationController(rootViewController: LoginController())
        present(navController, animated: true)
    }
    
    @objc fileprivate func fetchPosts() {
        let url = "http://localhost:1337/post"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData{ (dataResp) in
                if let err = dataResp.error {
                    print("Failed to fetch posts:", err)
                    return
                }
                
                guard let data = dataResp.data else { return }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    self.posts = posts
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
    }
    
    var posts = [Post]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.user.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.text = post.text
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}
