//
//  GroupsAndFriendsTableViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 11.02.2022.
//

import UIKit

class GroupsAndFriendsTableViewCell: UITableViewCell {

    

    @IBOutlet weak var descriptionLabelCell: UILabel!
    @IBOutlet weak var titleLabelCell: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabelCell.text = nil
        descriptionLabelCell = nil
        imageViewCell.image = nil
    }
    
    func setDataGroupList(group: Group) {
        if let avatarPath = group.avatarImagePath {
            imageViewCell.image = UIImage(named: avatarPath)
        }
        titleLabelCell.text = group.name
        descriptionLabelCell.text = group.description
        titleLabelCell.textColor = .white
        descriptionLabelCell.textColor = .lightGray
    }
    
    func setDataFriendsList(friendsList: FriendsList) {
        if let avatarPath = friendsList.avatarImagePath {
            imageViewCell.image = UIImage(named: avatarPath)
        }
        titleLabelCell.text = friendsList.name
        descriptionLabelCell.text = friendsList.messadge
        titleLabelCell.textColor = .white
        descriptionLabelCell.textColor = .lightGray
    }
    
}
