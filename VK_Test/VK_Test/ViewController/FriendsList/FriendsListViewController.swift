//
//  FriendsListViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 11.02.2022.
//

import UIKit

class FriendsListViewController: UIViewController {

    @IBOutlet weak var friendsListTableView: UITableView!
    
    let friendsListIdentifier = "friendsListIdentifier"
    var friendsListArray = [FriendsList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsListTableView.dataSource = self
        friendsListTableView.delegate = self
        registerCell()
        createFriendsListArray()
        friendsListTableView.reloadData()
    }
}

extension FriendsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsListIdentifier, for: indexPath) as? GroupsAndFriendsTableViewCell else {return UITableViewCell()}
        
        cell.setDataFriendsList(friendsList: friendsListArray[indexPath.row])
        return cell
    }
}

extension FriendsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(friendsListArray[indexPath.row].name) friend")
    }
}

extension FriendsListViewController {
    func createFriendsListArray() {
        let friend1 = FriendsList(avatarImagePath: "angelinaJolie", name: "Angelina Jolie", messadge: "Hi Angelina")
        friendsListArray.append(friend1)
        let friend2 = FriendsList(avatarImagePath: "djonnyDep", name: "Djonny Dep", messadge: "Hello")
        friendsListArray.append(friend2)
        let friend3 = FriendsList(avatarImagePath: "dueinJonson", name: "Duein Jonson", messadge: "Whot are you doing now?")
        friendsListArray.append(friend3)
        let friend4 = FriendsList(avatarImagePath: "gisseleBeyonce", name: "Gissele Beyonce", messadge: nil)
        friendsListArray.append(friend4)
        let friend5 = FriendsList(avatarImagePath: "uillSmith", name: "Uill Smith", messadge: "How are you?")
        friendsListArray.append(friend5)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Friends"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friendsListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

extension FriendsListViewController {
    func registerCell() {
        friendsListTableView.register(UINib(nibName: "GroupsAndFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: friendsListIdentifier)
    }
}
