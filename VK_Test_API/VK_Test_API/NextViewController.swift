//
//  NextViewController.swift
//  VK_Test_API
//
//  Created by Александр Шербуренко on 01.04.2022.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class NextViewController: UIViewController {
    
    let host = "https://api.vk.com"

    override func viewDidLoad() {
        super.viewDidLoad()
//        loadUsers()
        getPhotos()
        getGroupsList()
        getFriendsList()
        getSearchGroupsList()
    }
}

extension NextViewController {
    func getFriendsList() {
        
        let path = "/method/friends.get"
        
        let parameters = [
            "user_id": String(Session.shared.userID),
            "order": "random",
            "access_token": Session.shared.token,
            "v": "5.131"
        ]
        
        AF
            .request(host + path,
                     method: .get,
                     parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let friends = Friends0(json)
                    print(friends)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension NextViewController {
    func getPhotos() {
        let path = "/method/photos.get"
        
        let parameters = [
            "owner_id": String(Session.shared.userID),
            "album_id": "profile",
            "rev": "0",
            "access_token": Session.shared.token,
            "v": "5.131"
        ]
        
        AF
            .request(host + path,
                     method: .get,
                     parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    let json = JSON(data)
                    let photos = Photos0(json)
                    print(photos)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension NextViewController {
    func getGroupsList() {
        let path = "/method/groups.get"
        
        let parameters = [
            "user_id": String(Session.shared.userID),
            "extended": "0",
            "access_token": Session.shared.token,
            "v": "5.131"
        ]
        
        AF
            .request(host + path,
                     method: .get,
                     parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let groups = Groups(json)
                    print(groups)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension NextViewController {
    func getSearchGroupsList() {
        let path = "/method/groups.search"
        
        let parameters = [
            "q": "Music",
            "offset": "3",
            "count": "3",
            "access_token": Session.shared.token,
            "v": "5.131"
        ]
        
        AF
            .request(host + path,
                     method: .get,
                     parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    let json = JSON(data)
                    let search = Search(json)
                    print(search)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension NextViewController {
    func loadUsers() {
        AF
            .request("https://jsonplaceholder.typicode.com/users", method: .get)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    let json = JSON(data)
                    let users = json.arrayValue.compactMap{ User0($0) }
                    print(users)
//                    print(data)
//                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
//
//                    let decoder = JSONDecoder()
//                    let user = try? decoder.decode([User].self, from: data)
//                    user?.forEach{ user in
//                        print("\(user.id): \(user.name)")
//                    }
//                    print(json)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
