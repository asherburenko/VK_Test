//
//  NextViewController.swift
//  VK_Test_API
//
//  Created by Александр Шербуренко on 01.04.2022.
//

import UIKit
import WebKit

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
        getGroupsList()
        getFriendsList()
        getSearchGroupsList()
    }
}

extension NextViewController {
    func getFriendsList() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userID)),
            URLQueryItem(name: "order", value: "random"),
            //URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print("FriendList", json)
        }
        task.resume()
    }
}

extension NextViewController {
    func getPhotos() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: String(Session.shared.userID)),
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "rev", value: "0"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print("Photo", json)
        }
        task.resume()
    }
}

extension NextViewController {
    func getGroupsList() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userID)),
            URLQueryItem(name: "extended", value: "0"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print("Groups", json)
        }
        task.resume()
    }
}

extension NextViewController {
    func getSearchGroupsList() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "Music"),
           // URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "offset", value: "3"),
            URLQueryItem(name: "count", value: "3"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print("Search", json)
        }
        task.resume()
    }
}
