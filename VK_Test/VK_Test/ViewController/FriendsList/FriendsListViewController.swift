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
    let friendsGalleryId = "fromFriendsGallery"
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
        
        cell.setDataFriendsList(friendsList: friendsListArray[indexPath.row], completion: {[weak self] in
            guard let self = self else {return}
            self.performSegue(withIdentifier: self.friendsGalleryId, sender: self.friendsListArray[indexPath.row].fotos)
        })
        return cell
    }
}

extension FriendsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(friendsListArray[indexPath.row].name) friend")

        performSegue(withIdentifier: friendsGalleryId, sender: friendsListArray[indexPath.row].fotos)
    }
}

extension FriendsListViewController {
    func createFriendsListArray() {
        let friend1 = FriendsList(avatarImagePath: "angelinaJolie", name: "Angelina Jolie", messadge: "Hi Angelina", fotos: ["angelinaJolie1", "angelinaJolie2", "angelinaJolie3"])
        friendsListArray.append(friend1)
        let friend2 = FriendsList(avatarImagePath: "djonnyDep", name: "Djonny Dep", messadge: "Hello", fotos: ["djonnyDep1", "djonnyDep2", "djonnyDep3"])
        friendsListArray.append(friend2)
        let friend3 = FriendsList(avatarImagePath: "dueinJonson", name: "Duein Jonson", messadge: "Whot are you doing now?", fotos: ["dueinJonson1", "dueinJonson2", "dueinJonson3"])
        friendsListArray.append(friend3)
        let friend4 = FriendsList(avatarImagePath: "gisseleBeyonce", name: "Gissele Beyonce", messadge: nil, fotos: ["gisseleBeyonce1", "gisseleBeyonce2", "gisseleBeyonce3"])
        friendsListArray.append(friend4)
        let friend5 = FriendsList(avatarImagePath: "uillSmith", name: "Uill Smith", messadge: "How are you?", fotos: ["uillSmith"])
        friendsListArray.append(friend5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == friendsGalleryId {
            guard let destinationVC = segue.destination as? GalleryViewController,
                  let fotoArray = sender as? [String]
            else { return }
            
            destinationVC.fotoArray = fotoArray
        }
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
