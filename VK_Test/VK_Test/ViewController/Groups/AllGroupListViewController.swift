//
//  AllGroupListViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 11.02.2022.
//

import UIKit

class AllGroupListViewController: UIViewController {

    @IBOutlet weak var allGroupListTableView: UITableView!
    
    let groupsAndFriendsCellIdentifier = "groupsAndFriendsCellIdentifier"
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allGroupListTableView.dataSource = self
        allGroupListTableView.delegate = self
        registerTableView()
        createGroupsArray()
        allGroupListTableView.reloadData()
    }
}

extension AllGroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupsAndFriendsCellIdentifier, for: indexPath) as? GroupsAndFriendsTableViewCell else { return UITableViewCell()}
        
        cell.setData(group: groupsArray[indexPath.row])
        return cell
    }
}

extension AllGroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(groupsArray[indexPath.row].name) group")
    }
}

extension AllGroupListViewController {
    func createGroupsArray() {
        let group1 = Group(avatarImagePath: "cars", name: "Cars funs", description: nil)
        groupsArray.append(group1)
        let group2 = Group(avatarImagePath: "students", name: "Students", description: nil)
        groupsArray.append(group2)
        let group3 = Group(avatarImagePath: "news", name: "News", description: nil)
        groupsArray.append(group3)
        let group4 = Group(avatarImagePath: "apple", name: "Apple funs", description: nil)
        groupsArray.append(group4)
        let group5 = Group(avatarImagePath: "motocicle", name: "Motocicle funs", description: nil)
        groupsArray.append(group5)
    }
}

extension AllGroupListViewController {
    func registerTableView() {
        allGroupListTableView.register(UINib(nibName: "GroupsAndFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: groupsAndFriendsCellIdentifier)
    }
}
