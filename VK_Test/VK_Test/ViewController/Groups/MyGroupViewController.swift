//
//  MyGroupViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 17.02.2022.
//

import UIKit

class MyGroupViewController: UIViewController {
    
    @IBOutlet weak var myGroupTableView: UITableView!
    
    let myGroupsCellIdentifier = "myGroupsCellIdentifier"
    var myGroupArray = [Group]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myGroupTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myGroupTableView.dataSource = self
        myGroupTableView.delegate = self
        notification()
        registerTableView()
    }
}

extension MyGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: myGroupsCellIdentifier, for: indexPath) as? GroupsAndFriendsTableViewCell else { return UITableViewCell()}
        
        cell.setDataGroupList(group: myGroupArray[indexPath.row])
        return cell
    }
}

extension MyGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(myGroupArray[indexPath.row].name) group")
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
