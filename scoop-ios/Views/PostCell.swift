//
//  PostCell.swift
//  scoop-ios
//
//  Created by Shane Alton on 10/18/21.
//

import LBTATools

class PostCell: UITableViewCell {
    
    let usernameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 15))
    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postTextLabel = UILabel(text: "Post text spanning multiple lines.", font: .systemFont(ofSize: 15), numberOfLines: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor).isActive = true
        
        stack(stack(usernameLabel).padLeft(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
