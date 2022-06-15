//
//  NewsViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    let newsIdentifier = "newsIdentifier"
    
    let host = "https://api.vk.com"
    
    
    private lazy var news = try? Realm().objects(NewsRealm.self)
    private var photoService: PhotoService?
    private let service = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        photoService = PhotoService(container: newsTableView)
        registerCell()
        setup()
        service.getNews()
        self.newsTableView.reloadData()
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsAndFriendsTableViewCell.identifier, for: indexPath) as? GroupsAndFriendsTableViewCell else {return UITableViewCell()}
            
            guard let urlImage = news?[indexPath.section].avatar else { return UITableViewCell() }
            let avatar = photoService?.photo(atIndexPath: indexPath, byUrl: urlImage)
            cell.setDataNewsFileManager(news: (news?[indexPath.section])!, avatar: avatar)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTextTableViewCell.identifier, for: indexPath) as? NewsTextTableViewCell else {return UITableViewCell()}
            
            cell.setDataNewsText(news: (news?[indexPath.section])!)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsImageTableViewCell.identifier, for: indexPath) as? NewsImageTableViewCell else {return UITableViewCell()}
            
            cell.setDataNewsImage(news: (news?[indexPath.section])!)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsLikeTableViewCell.identifier, for: indexPath) as? NewsLikeTableViewCell else {return UITableViewCell()}
            
            cell.setDataLike(news: (news?[indexPath.section])!)
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
        newsTableView.register(UINib(nibName: "GroupsAndFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: GroupsAndFriendsTableViewCell.identifier)
        newsTableView.register(UINib(nibName: "NewsTextTableViewCell", bundle: nil), forCellReuseIdentifier: NewsTextTableViewCell.identifier)
        newsTableView.register(UINib(nibName: "NewsImageTableViewCell", bundle: nil), forCellReuseIdentifier: NewsImageTableViewCell.identifier)
        newsTableView.register(UINib(nibName: "NewsLikeTableViewCell", bundle: nil), forCellReuseIdentifier: NewsLikeTableViewCell.identifier)
    }
}

extension NewsViewController {
    func setup() {
        newsTableView.backgroundColor = .darkGray
    }
}
