//
//  FriendRealm.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 20.04.2022.
//

import Foundation
import RealmSwift

class FriendRealm: Object {
    @objc dynamic var avatarImagePath = ""
    @objc dynamic var name = ""
    @objc dynamic var massadge = "Hi"
    @objc dynamic var fotos = ""
    @objc dynamic var id = ""
    
    convenience init(avatarImagePath: String, name: String, massadge: String, fotos: String, id: String) {
        self.init()
        self.avatarImagePath = avatarImagePath
        self.name = name
        self.massadge = massadge
        self.fotos = fotos
        self.id = id
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}
