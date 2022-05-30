//
//  NewsViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    let newsIdentifier = "newsIdentifier"
    let newsAvatarIdentifier = "newsAvatarIdentifier"
    let newsTextIdentifier = "newsTextIdentifier"
    let newsImageIdentifier = "newsImageIdentifier"
    let newsLikeIdentifier = "newsLikeIdentifier"
    
    var selectedIndex = NSIndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        registerCell()
        setup()
        newsTableView.reloadData()
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsAvatarIdentifier, for: indexPath) as? GroupsAndFriendsTableViewCell else {return UITableViewCell()}
        
            cell.setDataNews(avatar: "cars", name: "Cars Lovers", date: "сегодня в 02:35")
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTextIdentifier, for: indexPath) as? NewsTextTableViewCell else {return UITableViewCell()}
            
            cell.setDataNewsText(text: "В ГИБДД России оценили новую моду среди автомобилистов по установке так называемых 3D-госномеров. С таким запросом ранее Autonews.ru обратился в ведомство после общения с инспекторами ГИБДД, которые сообщили о необычных табличках с объемными пластиковыми накладками. В ведомстве предупредили: с таким госномером не по ГОСТу отделаться более легкой статьей за нечитаемые номера и штрафом в 500 руб. не получится. Водителей за такие номера будут наказывать лишением прав от шести месяцев до года согласно более жесткой норме законодательства: ч.4 ст. 12.2 КоАП «Управление транспортным средством с заведомо подложными государственными регистрационными знаками».")
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsImageIdentifier, for: indexPath) as? NewsImageTableViewCell else {return UITableViewCell()}
            
            cell.setDataNewsImage(image: "CarsNews")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsLikeIdentifier, for: indexPath) as? NewsLikeTableViewCell else {return UITableViewCell()}
            
            cell.setDataLike(like: 123, message: 456, repost: 789, views: 58)
            return cell
        }
    }
}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else if indexPath.row == 1 {
            return 200
        } else if indexPath.row == 2 {
            return 250
        } else {
            return 70
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
    func setup() {
        newsTableView.backgroundColor = .darkGray
    }
}
