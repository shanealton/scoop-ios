//
//  CreatePostController.swift
//  scoop-ios
//
//  Created by Shane Alton on 10/18/21.
//

import LBTATools
import Alamofire
import JGProgressHUD

class CreatePostController: UIViewController, UITextViewDelegate {
    
    let selectedImage: UIImage
    
    //Use this upon dismiss later.
    weak var homeController: HomeController?
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        super.init(nibName: nil, bundle: nil)
        imageView.image = selectedImage
    }
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    lazy var postButton = UIButton(title: "Post", titleColor: .white, font: .boldSystemFont(ofSize: 14), backgroundColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), target: self, action: #selector(handlePost))
    
    let placeholderLabel = UILabel(text: "Enter your post body text...", font: .systemFont(ofSize: 14), textColor: .lightGray)
    
    let postBodyTextView = UITextView(text: nil, font: .systemFont(ofSize: 14))
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //UI Layout
        postButton.layer.cornerRadius = 5
        view.stack(imageView.withHeight(300),
                   view.stack(postButton.withHeight(40),
                              placeholderLabel,
                              spacing: 16).padLeft(16).padRight(16),
                   UIView(),
                   spacing: 16)
        
        //Setup UITextView on top of placeholder label. UITextView does not have a placeholder property.
        view.addSubview(postBodyTextView)
        postBodyTextView.backgroundColor = .clear
        postBodyTextView.delegate = self
        postBodyTextView.anchor(top: placeholderLabel.bottomAnchor, leading: placeholderLabel.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -25, left: -6, bottom: 0, right: 16))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.alpha = !textView.text.isEmpty ? 0 : 1
    }
    
    @objc fileprivate func handlePost() {
        let url = "http://localhost:1337/post"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data", "Accept": "application/json"]
        
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Uploading"
        hud.show(in: view)
        
        guard let text = postBodyTextView.text else { return }
        
        AF.upload(multipartFormData: { (formData) in
            // Post Text
            formData.append(Data(text.utf8), withName: "postBody")

            // Post Image
            guard let imageData = self.selectedImage.jpegData(compressionQuality: 0.5) else { return }
            formData.append(imageData, withName: "imagefile", fileName: "Doesn'tMatterSoMuch", mimeType: "image/jpg")
        }, to: url,
        method: .post,
        headers: headers).uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            DispatchQueue.main.async {
                hud.progress = Float(progress.fractionCompleted)
                hud.textLabel.text = "Uploading\n\(Int(progress.fractionCompleted * 100))% Complete"
            }
        }).responseJSON(completionHandler: { data in
        }).response { dataResp in
            switch dataResp.result {
            case .success(let result):
                hud.dismiss()
                
                if let err = dataResp.error {
                    print("Failed to hit server:", err)
                    return
                }

                if let code = dataResp.response?.statusCode, code >= 300 {
                    print("Failed to upload with status: ", code)
                    return
                }

                print("Successfully created post, here is the response:")
                
                self.dismiss(animated: true) {
                    self.homeController?.fetchPosts()
                }
            case .failure(let err):
                print("upload err: \(err)")
            }
        }
    }
}
