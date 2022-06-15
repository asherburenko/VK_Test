//
//  NetworkingService.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 14.06.2022.
//

import UIKit
import PromiseKit
import RealmSwift
import Alamofire

class NetworkingService {
    
    private let constants = Constant()
    private var urlConstructor = URLComponents()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!

    init() {
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func  getAuthorizeRequest() -> URLRequest? {
        urlConstructor.host = "oauth.vk.com"
        urlConstructor.path = "/authorize"

        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: constants.clientID),
            URLQueryItem(name: "scope", value: constants.scope),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: constants.versionAPI)
        ]

        guard let url = urlConstructor.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    func realmErase() {
        let realm = try? Realm()
        try? realm?.write({
            realm?.deleteAll()
        })
    }
    
    //MARK: - Groups feed
    func getUrlGroups() -> Promise<URL> {
        urlConstructor.path = "/method/groups.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userID)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: constants.versionAPI)
        ]
        
        return Promise  { resolver in
            guard let url = urlConstructor.url else {
                resolver.reject(AppError.notCorrectUrl)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    func getDataGroups(_ url: URL) -> Promise<Data> {
        return Promise { resolver in
            session.dataTask(with: url) {  (data, response, error) in
                guard let data = data else {
                    resolver.reject(AppError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    func getParsedDataGroups(_ data: Data) -> Promise<ItemsGroups> {
        return Promise  { resolver in
            do {
                let response = try JSONDecoder().decode(ResponseGroups.self, from: data).response
                resolver.fulfill(response)
            } catch {
                resolver.reject(AppError.failedToDecode)
            }
        }
    }
    
    func getRealmGroups(_ data: ItemsGroups) -> Promise<GroupsModel> {
        return Promise { resolver in
            for index in 0..<data.count {
                self.realmSaveGroups(data: data.items[index], index: index)
                resolver.fulfill(data.items[index])
            }
        }
    }

    func realmSaveGroups(data: GroupsModel, index: Int, configuration: Realm.Configuration = FriendsListViewController.deleteIfMigration, update: Realm.UpdatePolicy = .modified) {
        let group = GroupRealm()
        
        group.name = data.name
        group.photo = data.photo
        group.id = data.id
        group.count = index

        let realm = try? Realm(configuration: configuration)
        //print(configuration.fileURL ?? "Error")
        guard let oldGroup = realm?.objects(GroupRealm.self).filter("id == %@", data.id) else { return }
        try? realm?.write({
            realm?.delete(oldGroup)
            realm?.add(group)
        })
    }
    
    //MARK: - News feed
    func getNews() {
        urlConstructor.path = "/method/newsfeed.get"

        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userID)),
            URLQueryItem(name: "start_from", value: "next_from"),
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: constants.versionAPI)
        ]
        
        guard let url = urlConstructor.url else { return }
        print(url)
        
        AF.request(url).responseData { response in
            guard let data = response.value else { return }
            do {
                print(data)
                var news = try JSONDecoder().decode(News0.self, from: data).response.items
                let profiles = try? JSONDecoder().decode(News0.self, from: data).response.profiles
                let groups = try? JSONDecoder().decode(News0.self, from: data).response.groups
                
                for index in 0..<news.count {
                    if news[index].sourceID < 0 {
                        let group = groups?.first(where: { $0.id == -news[index].sourceID })
                        news[index].avatarURL = group?.avatarURL
                        news[index].creatorName = group?.name
                    } else {
                        let profile = profiles?.first(where: { $0.id == news[index].sourceID })
                        news[index].avatarURL = profile?.avatarURL
                        news[index].creatorName = (profile?.firstName ?? "") + (profile?.lastName ?? "")
                    }
                }
                
                self.realmErase()

                for index in 0..<news.count {
                    self.realmSaveNews(data: news[index], index: index)
                }
            } catch {
                print(error)
            }
        }
    }
    
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    func realmSaveNews(data: ItemNews, index: Int, configuration: Realm.Configuration = deleteIfMigration, update: Realm.UpdatePolicy = .modified) {
        let news = NewsRealm()
        
        news.avatar = data.avatarURL!
        news.sourceID = data.sourceID
        news.name = data.creatorName!
        news.date = data.date
        news.text = data.text
        news.likes = data.likes.count
        news.comments = data.comments.count
        news.reposts = data.reposts.count
        news.views = data.views.count
        news.photo = data.photoURL?.last ?? "https://cdn.ananasposter.ru/image/cache/catalog/poster/travel/85/9427-1000x830.jpg"
        
        let realm = try? Realm(configuration: configuration)
        try? realm?.write({
            realm?.add(news)
        })
    }
}
