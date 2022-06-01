//
//  NewsRealm.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 01.06.2022.
//

import Foundation
import RealmSwift

class NewsRealm: Object {
    
    @objc dynamic var sourceID = ""
    @objc dynamic var name = ""
    @objc dynamic var avatar = ""
    @objc dynamic var date = ""
    @objc dynamic var text = ""
    @objc dynamic var likes = 0
    @objc dynamic var comments = 0
    @objc dynamic var reposts = 0
    @objc dynamic var views = 0
    @objc dynamic var typePhoto = ""
    @objc dynamic var photo = ""
    
    convenience init(sourceID: String, name: String, avatar: String, date: String, text: String, likes: Int, comments: Int, reposts: Int, views: Int, typePhoto: String, photo: String) {
        self.init()
        self.sourceID = sourceID
        self.name = name
        self.avatar = avatar
        self.text = text
        self.likes = likes
        self.comments = comments
        self.reposts = reposts
        self.views = views
        self.typePhoto = typePhoto
        self.photo = photo
    }
    
    override class func primaryKey() -> String? {
        "name"
    }
}
