//
//  HomeController.swift
//  scoop-ios
//
//  Created by Shane Alton on 10/12/21.
//

import LBTATools
import WebKit
import Alamofire
import SDWebImage

class HomeController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            .init(title: "Fetch Posts", style: .plain, target: self, action: #selector(fetchPosts)),
            .init(title: "Create Post", style: .plain, target: self, action: #selector(createPost))
        ]
        
        navigationItem.leftBarButtonItem = .init(title: "Login", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    @objc fileprivate func createPost() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        dismiss(animated: true) {
            let createPostController = CreatePostController(selectedImage: image)
            createPostController.homeController = self
            self.present(createPostController, animated: true)
        }
     }
    
    func imagePickerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        print("Show login and sign up pages")
        let navController = UINavigationController(rootViewController: LoginController())
        present(navController, animated: true)
    }
    
    @objc func fetchPosts() {
        Service.shared.fetchPosts {(res) in
            switch res {
            case .failure(let err):
                print("Failed to fetch posts:", err)
            case .success(let posts):
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
    
    var posts = [Post]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        
        cell.usernameLabel.text = post.user.name
        cell.postTextLabel.text = post.text
        cell.postImageView.sd_setImage(with: URL(string: post.imageUrl))
            
        return cell
    }
}
