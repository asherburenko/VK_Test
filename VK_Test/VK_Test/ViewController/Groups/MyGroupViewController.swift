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
import PromiseKit

class MyGroupViewController: UIViewController {
    
    @IBOutlet weak var myGroupTableView: UITableView!
    
    @IBOutlet weak var myGroupSearchBar: UISearchBar!
    
    let myGroupsCellIdentifier = "myGroupsCellIdentifier"

    var myGroupArray = [Group]()
    
    private lazy var groupRealm = try? Realm().objects(GroupRealm.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUrl()
            .then(on: .global(), getData(_:))
            .then(self.getParsedData(_:))
            .then(self.getRealm(_:))
            .done(on: .main) { groups in
                print("Complite")
            }.catch { error in
                print(error)
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
}

extension MyGroupViewController {
    func registerTableView() {
        myGroupTableView.register(UINib(nibName: "GroupsAndFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: myGroupsCellIdentifier)
    }
}

extension MyGroupViewController {
    func getUrl() -> Promise<String> {
        let host = "https://api.vk.com"
        let path = "/method/groups.get"
        let url = host + path
        
        return Promise { resolver in
            guard url != nil else {
                resolver.reject(("Not Coreect URL") as! Error)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    func getData(_ url: String) -> Promise<Data> {
        let parameters = [
            "user_id": String(Session.shared.userID),
            "extended": "1",
            "access_token": Session.shared.token,
            "v": "5.131"
        ]
        
        return Promise { resolver in
            AF
                .request(url,
                         method: .get,
                         parameters: parameters)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        resolver.fulfill(data)
                    case .failure(let error):
                        print(error)
                        resolver.reject(error)
                    }
                }.resume()
        }
    }
    
    func getParsedData(_ data: Data) -> Promise<Groups> {
        let json = JSON(data)
        let groups = Groups(json)
        
        return Promise { resolver in
            guard groups != nil else {
                resolver.reject(("ErrorParsed") as! Error)
                return
            }
            resolver.fulfill(groups)
        }
    }
    
    func getRealm(_ data: Groups) -> Promise<Groups> {
        var index = 0
        
        return Promise { resolver in
            for _ in data.name {
                self.realmSave(data: data, index: index)
                index += 1
            }
            myGroupTableView.reloadData()
            resolver.fulfill(data)
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
