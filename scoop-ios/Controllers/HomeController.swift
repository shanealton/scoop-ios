//
//  HomeController.swift
//  scoop-ios
//
//  Created by Shane Alton on 10/12/21.
//

import LBTATools
import WebKit

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
        print("Attempt to fetch posts while unauthorized")
        
        guard let url = URL(string: "http://localhost:1337/post") else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to hit server:", err)
                    return
                } else if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                    print("Failed to fetch posts, statusCode:", resp.statusCode)
                    return
                } else {
                    print("Successfully fetched posts, response data:")
                    let html = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    print(html)
                    let vc = UIViewController()
                    let webView = WKWebView()
                    webView.loadHTMLString(html, baseURL: nil)
                    vc.view.addSubview(webView)
                    webView.fillSuperview()
                    self.present(vc, animated: true)
                }
            }
        }.resume()
    }
}
