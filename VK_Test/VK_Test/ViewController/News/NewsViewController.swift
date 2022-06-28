//
//  NewsViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit
import RealmSwift
import CoreMedia

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    let newsIdentifier = "newsIdentifier"
    let host = "https://api.vk.com"
    
    private lazy var news = try? Realm().objects(NewsRealm.self)
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    private var photoService: PhotoService?
    private let service = NetworkingService()
    
    private var lastDate: Double = 0.0
    static var nextForm = ""
    static var isLoading = false
    
    private var dataBaseNotificationToken: NotificationToken?
    private var resultNotificationToken: NotificationToken?
    private var objectNotificationTocen: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.prefetchDataSource = self
        
        photoService = PhotoService(container: newsTableView)
        registerCell()
        setup()
        
        service.realmErase()
        setupRefreshControl()
        service.getNews()
        realmNotification(tableViewNotification: newsTableView)
        
        self.newsTableView.reloadData()
    }
    
    deinit {
        dataBaseNotificationToken?.invalidate()
        resultNotificationToken?.invalidate()
        objectNotificationTocen?.invalidate()
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
            if (news?[indexPath.section].text.isEmpty)! {
                return 0
            }
            return UITableView.automaticDimension
        case 2:
            if (news?[indexPath.section].photo.isEmpty)! {
                return 0
            } else {
                let width = newsTableView.frame.width
                let post = news?[indexPath.section]
                let cellHeight = width * (post?.aspectRatio ?? 0)
                print(cellHeight)
                return cellHeight
            }
        case 3:
            return 70
        default:
            return UITableView.automaticDimension
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
    // Функция настройки контроллера
    fileprivate func setupRefreshControl() {
        // Инициализируем и присваиваем сущность UIRefreshControl
        newsTableView.refreshControl = UIRefreshControl()
        // Настраиваем свойства контрола, как, например,
        // отображаемый им текст
        newsTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        // Цвет спиннера
        newsTableView.refreshControl?.tintColor = .gray
        // И прикрепляем функцию, которая будет вызываться контролом
        newsTableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        lastDate = news?.first?.date ?? 0
        let date = Int(lastDate)
        
        service.getNewsWriteTime(date)
        newsTableView.reloadData()
        newsTableView.refreshControl?.endRefreshing()
    }
    
    private func realmNotification(tableViewNotification: UITableView) {
        do {
            let realm = try Realm()
           // DataBase Notification
            dataBaseNotificationToken = realm.observe({ notification, realm in
            })
            
            // Object notification
            let news = realm.objects(NewsRealm.self)
            resultNotificationToken = news.observe({ change in
                let tableView = tableViewNotification
                switch change {
                case .initial(_):
                    tableViewNotification.reloadData()
                    print("initial case")
                case let .update(_,
                             deletions,
                             insertions,
                             modifications):
                    print(deletions)
                    print(insertions)
                    print(modifications)
                    let indexSetInsertions = IndexSet(integer: insertions.first ?? 0)
                    tableView.beginUpdates()
                    tableView.insertSections(indexSetInsertions, with: .automatic)
                    tableView.endUpdates()
                    tableViewNotification.reloadData()
                case .error(let error):
                    print(error)
                }
            })
        } catch {
            print(error)
        }
    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else {
            return
        }
        
        if maxSection > news!.count - 3,
           !NewsViewController.isLoading {
            NewsViewController.isLoading = true
            
            service.getNewsScrolling(NewsViewController.nextForm)
            newsTableView.reloadData()
        }
    }
}

extension NewsViewController {
    func setup() {
        newsTableView.backgroundColor = .darkGray
    }
}
