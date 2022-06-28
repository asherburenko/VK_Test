//
//  NewsModel.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 15.06.2022.
//

import UIKit

struct News: Codable {
    let response: ResponseNews
}

struct ResponseNews: Codable {
    let items: [ItemNews]
    let profiles: [ProfilesNews]
    let groups: [GroupsNews]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}

struct ItemNews: Codable {
    let sourceID: Int
    let date: Double
    let text: String
    let attachments: [Attachments]?
    let comments: ComentModel
    let likes: LikeModel
    let reposts: RepostModel
    let views: ViewsModel
    var avatarURL: String?
    var creatorName: String?
    var photoURL: [String]? {
        get {
            let photosURL = attachments?.compactMap{ $0.photo?.sizes?.last?.url }
            return photosURL
        }
    }
    var aspectRatio: CGFloat {
        get {
            let aspectRatio = attachments?.compactMap{ $0.photo?.sizes?.last?.aspectRatio }.last
            return aspectRatio ?? 1
        }
    }
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case attachments
        case comments
        case likes
        case reposts
        case views
        case avatarURL
    }
}

struct ProfilesNews: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarURL = "photo_100"
    }
}

struct GroupsNews: Codable {
    let id: Int
    let name: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "photo_100"
    }
}

struct Attachments: Codable {
    let type: String?
    let photo: PhotoNews?
}

struct PhotoNews: Codable {
    let id: Int?
    let ownerID: Int?
    let sizes: [SizeNews]?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
}

struct SizeNews: Codable {
    let type: String?
    let url: String?
    let width: Int?
    let height: Int?
    
    var aspectRatio: CGFloat { return CGFloat(height ?? 0)/CGFloat(width ?? 0) }
}

struct ComentModel: Codable {
    let count: Int
}

struct LikeModel: Codable {
    let count: Int
}

struct RepostModel: Codable {
    let count: Int
}

struct ViewsModel: Codable {
    let count: Int
}
