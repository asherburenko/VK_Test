//
//  GroupRealm.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 21.04.2022.
//

import Foundation
import RealmSwift

class GroupRealm: Object {
    @objc dynamic var count = 0
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    @objc dynamic var id = 0
    
    convenience init(count: Int, name: String, photo: String, id: Int) {
        self.init()
        self.count = count
        self.name = name
        self.photo = photo
        self.id = id
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
    
}
