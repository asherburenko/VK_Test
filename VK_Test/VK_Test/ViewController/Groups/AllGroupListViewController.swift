//
//  AllGroupListViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 11.02.2022.
//

import UIKit

class AllGroupListViewController: UIViewController {

    @IBOutlet weak var allGroupListTableView: UITableView!
    
    @IBOutlet weak var allGroupSearchBar: UISearchBar!
    
    let groupsCellIdentifier = "groupsCellIdentifier"
    var groupsArray = [Group]()
    var sourceGroupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allGroupListTableView.dataSource = self
        allGroupListTableView.delegate = self
        allGroupSearchBar.delegate = self
        registerTableView()
        createGroupsArray()
        groupsArray = sourceGroupsArray
        allGroupListTableView.reloadData()
    }
}

extension AllGroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupsCellIdentifier, for: indexPath) as? GroupsAndFriendsTableViewCell else { return UITableViewCell()}
        
        cell.setDataGroupList0(group: groupsArray[indexPath.row])
        return cell
    }
}

extension AllGroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(groupsArray[indexPath.row].name) group")
        
        NotificationCenter.default.post(name: allGroupsRowPressed, object: groupsArray[indexPath.row])
    }
    
}

extension AllGroupListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groupsArray = sourceGroupsArray
        } else {
            groupsArray = sourceGroupsArray.filter({ groupItem in groupItem.name.lowercased().contains(searchText.lowercased())})
        }
        allGroupListTableView.reloadData()
    }
}

extension AllGroupListViewController {
    func createGroupsArray() {
        let group1 = Group(avatarImagePath: "cars", name: "Cars funs", description: nil)
        sourceGroupsArray.append(group1)
        let group2 = Group(avatarImagePath: "students", name: "Students", description: nil)
        sourceGroupsArray.append(group2)
        let group3 = Group(avatarImagePath: "news", name: "News", description: nil)
        sourceGroupsArray.append(group3)
        let group4 = Group(avatarImagePath: "apple", name: "Apple funs", description: nil)
        sourceGroupsArray.append(group4)
        let group5 = Group(avatarImagePath: "motocicle", name: "Motocicle funs", description: nil)
        sourceGroupsArray.append(group5)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Group"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
}

extension AllGroupListViewController {
    func registerTableView() {
        allGroupListTableView.register(UINib(nibName: "GroupsAndFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: groupsCellIdentifier)
    }
}
