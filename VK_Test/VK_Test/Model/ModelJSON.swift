//
//  ModelJSON.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 19.04.2022.
//

import Foundation
import SwiftyJSON

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
