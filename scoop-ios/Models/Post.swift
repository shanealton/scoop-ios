//
//  Post.swift
//  scoop-ios
//
//  Created by Shane Alton on 10/15/21.
//

import Foundation

struct Post: Decodable {
    let id: String
    let text: String
    let createdAt: Int
    let imageUrl: String
    let user: User
}

struct User: Decodable {
    let id: String
    let name: String
}
