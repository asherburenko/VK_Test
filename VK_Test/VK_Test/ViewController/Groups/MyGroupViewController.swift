//
//  MyGroupViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 17.02.2022.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class MyGroupViewController: UIViewController {
    
    @IBOutlet weak var myGroupTableView: UITableView!
    
    @IBOutlet weak var myGroupSearchBar: UISearchBar!
    
    let myGroupsCellIdentifier = "myGroupsCellIdentifier"
    let host = "https://api.vk.com"

    var myGroupArray = [Group]()
    
    private lazy var groupRealm = try? Realm().objects(GroupRealm.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myGroupTableView.dataSource = self
        myGroupTableView.delegate = self
        notification()
        registerTableView()
        myGroupTableView.reloadData()
    }
    
}

extension MyGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupRealm?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: myGroupsCellIdentifier, for: indexPath) as? GroupsAndFriendsTableViewCell else { return UITableViewCell()}
        
        cell.setDataGroupList(group: (groupRealm?[indexPath.item])!)
        return cell
    }
}

extension MyGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(groupRealm?[indexPath.item].name ?? "error") group")
    }
    
    func notification() {
        NotificationCenter.default.addObserver(self, selector: #selector(allGroupsRowPress(_:)), name: allGroupsRowPressed, object: nil)
    }
    
    func isContain(group: Group) -> Bool {
        return myGroupArray.contains {groupItem in groupItem.name == group.name}
    }
    
    @objc func allGroupsRowPress(_ notification: Notification) {
        guard let group = notification.object as? Group else { return }
        if isContain(group: group) {
            print("такая группа уже есть")
        } else {
            myGroupArray.append(group)
        }
    }
}

extension MyGroupViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Group"
    }
}

extension MyGroupViewController {
    func registerTableView() {
        myGroupTableView.register(UINib(nibName: "GroupsAndFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: myGroupsCellIdentifier)
    }
}

extension MyGroupViewController {
    func getGroupsList() {
        let path = "/method/groups.get"
        
        let parameters = [
            "user_id": String(Session.shared.userID),
            "extended": "1",
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
                    var i = 0
                    for _ in groups.name {
                        self.realmSave(data: groups, index: i)
                        i = i + 1
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension MyGroupViewController {
    func realmSave(data: Groups, index: Int, configuration: Realm.Configuration = FriendsListViewController.deleteIfMigration, update: Realm.UpdatePolicy = .modified) {
        let group = GroupRealm()
        group.name = data.name[index]
        group.photo = data.photo[index]
        group.id = data.id[index]
        
        let realm = try? Realm(configuration: configuration)
        guard let oldGroup = realm?.objects(GroupRealm.self).filter("id == %@", data.id[index]) else { return }
        try? realm?.write({
            realm?.delete(oldGroup)
            realm?.add(group)
        })
    }
}
