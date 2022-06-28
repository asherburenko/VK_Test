//
//  MyGroupViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 17.02.2022.
//

import UIKit
import Alamofire
import RealmSwift
import PromiseKit

class MyGroupViewController: UIViewController {
    
    private let constants = Constant()
    private var urlConstructor = URLComponents()
    
    @IBOutlet weak var myGroupTableView: UITableView!
    @IBOutlet weak var myGroupSearchBar: UISearchBar!
    
    let myGroupsCellIdentifier = "myGroupsCellIdentifier"

    var myGroupArray = [Group]()
    
    private let service = NetworkingService()
    private lazy var groupRealm = try? Realm().objects(GroupRealm.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getUrlGroups()
            .get({ url in
                print(url)
            })
            .then(on: DispatchQueue.global(), service.getDataGroups(_:))
            .then(service.getParsedDataGroups(_:))
            .then(service.getRealmGroups(_:))
            .done(on: DispatchQueue.main) { groups in
                self.myGroupTableView.reloadData()
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
