//
//  FriendsListViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 11.02.2022.
//


import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class FriendsListViewController: UIViewController {

    @IBOutlet weak var friendsListTableView: UITableView!
    
    let friendsListIdentifier = "friendsListIdentifier"
    let friendsGalleryId = "fromFriendsGallery"
    let host = "https://api.vk.com"
    
    var friendsListArray = [FriendsList]()
    
    var dataBaseNotificationToken: NotificationToken?
    var resultNotificationToken: NotificationToken?
    var objectNotificationTocen: NotificationToken?
    
    private lazy var friend = try? Realm().objects(FriendRealm.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsListTableView.dataSource = self
        friendsListTableView.delegate = self
        getFriendsList()
        registerCell()
        notification()
        friendsListTableView.reloadData()
    }
    
    @IBAction func addFriendButton(_ sender: Any) {
        showAddFriendForm()
    }
    
    deinit {
        dataBaseNotificationToken?.invalidate()
        resultNotificationToken?.invalidate()
        objectNotificationTocen?.invalidate()
    }
}

extension FriendsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsListIdentifier, for: indexPath) as? GroupsAndFriendsTableViewCell else {return UITableViewCell()}
    
        cell.setDataFriendsList(friendsList: (friend?[indexPath.item])!, completion: {[weak self] in
            guard let self = self else {return}
            self.performSegue(withIdentifier: self.friendsGalleryId, sender: self.friend?[indexPath.item])
        })
        return cell
    }
}

extension FriendsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(friend?[indexPath.item]) friend")

        performSegue(withIdentifier: friendsGalleryId, sender: friend?[indexPath.item])
    }
}

extension FriendsListViewController {
    
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

extension FriendsListViewController {
    func getFriendsList() {
        
        let path = "/method/friends.get"
        
        let parameters = [
            "user_id": String(Session.shared.userID),
            "order": "random",
            "fields": "last_name, photo_100",
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
                    let friends = Friends0(json)
                    var index = 0
                    for _ in friends.firstName {
                        self.realmSave(data: friends, index: index)
                        index += 1
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension FriendsListViewController {
    
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    func realmSave(data: Friends0, index: Int, configuration: Realm.Configuration = deleteIfMigration, update: Realm.UpdatePolicy = .modified) {
        let friend = FriendRealm()
        friend.name = data.firstName[index] + " " + data.lastName[index]
        friend.id = data.id[index]
        friend.avatarImagePath = data.photo[index]
        friend.fotos = "https://cdn.ananasposter.ru/image/cache/catalog/poster/travel/85/9427-1000x830.jpg"
        friend.massadge = "Hi"
        
        let realm = try? Realm(configuration: configuration)
        print(configuration.fileURL ?? "1111")
        guard let oldFriend = realm?.objects(FriendRealm.self).filter("id == %@", data.id[index]) else { return }
        try? realm?.write({
            realm?.delete(oldFriend)
            realm?.add(friend)
        })
    }
}


extension FriendsListViewController {
    private func notification() {
        do {
            let realm = try Realm()
           // DataBase Notification
            dataBaseNotificationToken = realm.observe({ notification, realm in
            })
            
            // Object notification
            let friend = realm.objects(FriendRealm.self)
                .sorted(byKeyPath: "id")
            resultNotificationToken = friend.observe({ change in
                guard let tableView = self.friendsListTableView else { return }
                switch change {
                case .initial(_):
                    self.friendsListTableView.reloadData()
                    print("initial case")
                case let .update(_,
                             deletions,
                             insertions,
                             modifications):
                    print(deletions)
                    print(insertions)
                    print(modifications)
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)} ), with: .automatic)
                    tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)} ), with: .automatic)
                    tableView.endUpdates()
                    self.friendsListTableView.reloadData()
                case .error(let error):
                    print(error)
                }
            })
        } catch {
            print(error)
        }
    }
}

extension FriendsListViewController {
    func showAddFriendForm() {
        let alertController = UIAlertController(title: "Enter Friend Id", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in })
        let confimAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            guard let id = alertController.textFields?[0].text else { return }
            self?.addFriend(id: id)
        }
        alertController.addAction(confimAction)
        let canselAction = UIAlertAction(title: "Cansel", style: .cancel, handler: nil)
        alertController.addAction(canselAction)
        present(alertController, animated: true, completion: {  })
    }
    
    func addFriend(id: String) {
        let newFriend = FriendRealm()
        newFriend.id = id
        newFriend.name = "Alex Romanov"
        newFriend.avatarImagePath = "https://cs6.pikabu.ru/avatars/796/v796415-2103112820.jpg"
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(newFriend)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
