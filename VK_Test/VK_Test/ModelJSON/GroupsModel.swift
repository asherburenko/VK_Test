//
//  GroupsModel.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 14.06.2022.
//

import UIKit

struct ResponseGroups: Codable {
    let response: ItemsGroups
}


struct ItemsGroups: Codable {
    let count: Int
    let items: [GroupsModel]
}

struct GroupsModel: Codable {
    let id: Int
    let name: String
    let photo: String

    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo = "photo_100"
    }
}


