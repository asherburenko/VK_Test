//
//  NewsViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    let newsIdentifier = "newsIdentifier"
    let newsAvatarIdentifier = "newsAvatarIdentifier"
    let newsTextIdentifier = "newsTextIdentifier"
    let newsImageIdentifier = "newsImageIdentifier"
    let newsLikeIdentifier = "newsLikeIdentifier"
    
    let host = "https://api.vk.com"
    
    
    private lazy var news = try? Realm().objects(NewsRealm.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        getNewsFeed()
        registerCell()
        setup()
        newsTableView.reloadData()
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(news?.count ?? 0)
        return news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsAvatarIdentifier, for: indexPath) as? GroupsAndFriendsTableViewCell else {return UITableViewCell()}
            
            cell.setDataNews(news: (news?[indexPath.item])!)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTextIdentifier, for: indexPath) as? NewsTextTableViewCell else {return UITableViewCell()}
            
            cell.setDataNewsText(news: (news?[indexPath.item])!)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsImageIdentifier, for: indexPath) as? NewsImageTableViewCell else {return UITableViewCell()}
            
            cell.setDataNewsImage(news: (news?[indexPath.item])!)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsLikeIdentifier, for: indexPath) as? NewsLikeTableViewCell else {return UITableViewCell()}
            
            cell.setDataLike(news: (news?[indexPath.item])!)
            return cell
        default:
            print("Error newsTableView")
            return UITableViewCell()
        }
    }
}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100
        case 1:
            return 200
        case 2:
            return 250
        case 3:
            return 70
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.black
        return footerView
    }
}

extension NewsViewController {
    func registerCell() {
        newsTableView.register(UINib(nibName: "GroupsAndFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: newsAvatarIdentifier)
        newsTableView.register(UINib(nibName: "NewsTextTableViewCell", bundle: nil), forCellReuseIdentifier: newsTextIdentifier)
        newsTableView.register(UINib(nibName: "NewsImageTableViewCell", bundle: nil), forCellReuseIdentifier: newsImageIdentifier)
        newsTableView.register(UINib(nibName: "NewsLikeTableViewCell", bundle: nil), forCellReuseIdentifier: newsLikeIdentifier)
    }
}

extension NewsViewController {
        func getNewsFeed() {
                let path = "/method/newsfeed.get"
                
                let parameters = [
                    "user_id": String(Session.shared.userID),
                    "filters": "post",
                    "max_photos": "1",
                    "source_ids": "friends,groups,pages",
                    "count": "5",
                    "fields": "name, photo_100",
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
                            let news = News(json)
                            var index = 0
                            for _ in news.sourceID {
                                self.realmSave(data: news, index: index)
                                index += 1
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
        }
}


extension NewsViewController {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    func realmSave(data: News, index: Int, configuration: Realm.Configuration = deleteIfMigration, update: Realm.UpdatePolicy = .modified) {
        let news = NewsRealm()
        news.sourceID = data.sourceID[index]
        news.name = data.name[index]
        news.avatar = data.avatar[index]
        news.date = data.date[index]
        news.text = data.text[index]
        news.likes = data.likes[index]
        news.comments = data.comments[index]
        news.reposts = data.reposts[index]
        news.views = data.views[index]
        news.typePhoto = "x"
        news.photo = "https://cdn.ananasposter.ru/image/cache/catalog/poster/travel/85/9427-1000x830.jpg"
        
        let realm = try? Realm(configuration: configuration)
        try? realm?.write({
            realm?.add(news)
        })
    }
}

extension NewsViewController {
    func realmErase() {
        let realm = try? Realm()
        try? realm?.write({
            realm?.deleteAll()
        })
    }
}

extension NewsViewController {
    func setup() {
        newsTableView.backgroundColor = .darkGray
    }
}
