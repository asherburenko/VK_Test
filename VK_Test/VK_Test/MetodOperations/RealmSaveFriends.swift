//
//  RealmSaveFriends.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 03.06.2022.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class RealmSaveFriends: Operation {
    
    override func main() {
        var index = 0
        for _ in GetAPIDataFriends.data!.firstName {
            self.realmSave(data: GetAPIDataFriends.data!, index: index)
            index += 1
        }
    }
    
    func realmSave(data: Friends0, index: Int, configuration: Realm.Configuration = .defaultConfiguration, update: Realm.UpdatePolicy = .modified) {
        let friend = FriendRealm()
        friend.name = data.firstName[index] + " " + data.lastName[index]
        friend.id = data.id[index]
        friend.avatarImagePath = data.photo[index]
        friend.fotos = "https://cdn.ananasposter.ru/image/cache/catalog/poster/travel/85/9427-1000x830.jpg"
        friend.massadge = "Hi"
        
        let realm = try? Realm(configuration: configuration)
        print(configuration.fileURL ?? "1111")
        guard let oldFriend = realm?.objects(FriendRealm.self).filter("id == %@", data.id[index]) else { return }
        try? realm?.write({
            realm?.delete(oldFriend)
            realm?.add(friend)
        })
    }
}
