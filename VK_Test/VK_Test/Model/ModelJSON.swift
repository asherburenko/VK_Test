//
//  ModelJSON.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 19.04.2022.
//

import Foundation
import SwiftyJSON

struct News {
    let sourceID: [String]
    let name: [String]
    let avatar: [String]
    let date: [String]
    let text: [String]
    let likes: [Int]
    let comments: [Int]
    let reposts: [Int]
    let views: [Int]

    
    init(_ json: JSON) {
        self.sourceID = json["response"]["items"].arrayValue.map({$0["source_id"].stringValue})
        self.name = json["response"]["groups"].arrayValue.map({$0["name"].stringValue})
        self.avatar = json["response"]["groups"].arrayValue.map({$0["photo_100"].stringValue})
        self.date = json["response"]["items"].arrayValue.map({$0["date"].stringValue})
        self.text = json["response"]["items"].arrayValue.map({$0["text"].stringValue})
        self.likes = json["response"]["items"].arrayValue.map({$0["likes"]["count"].intValue})
        self.comments = json["response"]["items"].arrayValue.map({$0["comments"]["count"].intValue})
        self.reposts = json["response"]["items"].arrayValue.map({$0["reposts"]["count"].intValue})
        self.views = json["response"]["items"].arrayValue.map({$0["views"]["count"].intValue})
    }
    
}

struct Friends0 {
    let count: Int
    let firstName: [String]
    let lastName: [String]
    let photo: [String]
    let id: [String]

    init(_ json: JSON) {
        self.count = json["response"]["count"].intValue
        self.firstName = json["response"]["items"].arrayValue.map({$0["first_name"].stringValue})
        self.lastName = json["response"]["items"].arrayValue.map({$0["last_name"].stringValue})
        self.photo = json["response"]["items"].arrayValue.map({$0["photo_100"].stringValue})
        self.id = json["response"]["items"].arrayValue.map({$0["id"].stringValue})
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
    let name: [String]
    let photo: [String]
    let id: [String]
    
    init(_ json: JSON) {
        self.count = json["response"]["count"].intValue
        self.name = json["response"]["items"].arrayValue.map({$0["name"].stringValue})
        self.photo = json["response"]["items"].arrayValue.map({$0["photo_100"].stringValue})
        self.id = json["response"]["items"].arrayValue.map({$0["id"].stringValue})
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
