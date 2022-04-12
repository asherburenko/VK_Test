//
//  User.swift
//  VK_Test_API
//
//  Created by Александр Шербуренко on 02.04.2022.
//

import Foundation
import SwiftyJSON

struct User: Codable {
    let id: Int
    let name: String
    let address: Address
}

struct Address: Codable {
    let city: String
    let geo: Location
}

struct Location: Codable {
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}

struct User0 {
    let id: Int
    let name: String
    let city: String
    let latitude: String
    let longitude: String
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.city = json["address"]["city"].stringValue
        self.latitude = json["address"]["geo"]["lat"].stringValue
        self.longitude = json["address"]["geo"]["lng"].stringValue
    }
}

struct Friends0 {
    let count: Int
    let friends: [JSON]

    init(_ json: JSON) {
        self.count = json["response"]["count"].intValue
        self.friends = json["response"]["items"].arrayValue
    }
}

struct Photos0 {
    let count: Int
    let photoId: [Int]
    let height: [[Int]]
    let width: [[Int]]
    let type: [[String]]
    let url: [[String]]
    
    init(_ json: JSON) {
        self.count = json["response"]["count"].intValue
        self.photoId = json["response"]["items"].arrayValue.map({ $0["id"].intValue })
        self.height = json["response"]["items"].arrayValue.map({ $0["sizes"].arrayValue.map({ $0["height"].intValue }) })
        self.width = json["response"]["items"].arrayValue.map({ $0["sizes"].arrayValue.map({ $0["width"].intValue }) })
        self.type = json["response"]["items"].arrayValue.map({ $0["sizes"].arrayValue.map({ $0["type"].stringValue }) })
        self.url = json["response"]["items"].arrayValue.map({ $0["sizes"].arrayValue.map({ $0["url"].stringValue }) })
    }
}

struct Groups {
    let count: Int
    let groups: [JSON]
    
    init(_ json: JSON) {
        self.count = json["response"]["count"].intValue
        self.groups = json["response"]["items"].arrayValue
    }
}

struct Search {
    let id: [Int]
    let name: [String]
    let type: [String]
    let photo: [String]
    
    init(_ json: JSON) {
        self.id = json["response"]["items"].arrayValue.map({ $0["id"].intValue })
        self.name = json["response"]["items"].arrayValue.map({ $0["name"].stringValue })
        self.type = json["response"]["items"].arrayValue.map({ $0["type"].stringValue })
        self.photo = json["response"]["items"].arrayValue.map({ $0["photo_200"].stringValue })
    }
}
