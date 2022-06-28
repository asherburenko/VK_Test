//
//  ModelJSON.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 19.04.2022.
//

import UIKit
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



