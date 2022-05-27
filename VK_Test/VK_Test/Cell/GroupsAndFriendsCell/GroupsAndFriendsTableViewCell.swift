//
//  GroupsAndFriendsTableViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 11.02.2022.
//

import UIKit
import Kingfisher

class GroupsAndFriendsTableViewCell: UITableViewCell {

    

    @IBOutlet weak var descriptionLabelCell: UILabel!
    @IBOutlet weak var titleLabelCell: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    
    var completion: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabelCell.text = nil
        descriptionLabelCell.text = nil
        imageViewCell.image = nil
        completion = nil
    }
    
    func setDataGroupList0(group: Group) {
        if let avatarPath = group.avatarImagePath {
            imageViewCell.image = UIImage(named: avatarPath)
        }
        titleLabelCell.text = group.name
    }
    
    func setDataGroupList(group: GroupRealm) {
        let avatarPath = group.photo
        let url = URL(string: avatarPath)
        imageViewCell.kf.setImage(with: url)
        
        titleLabelCell.text = group.name
    }
    
    func setDataFriendsList(friendsList: FriendRealm, completion: @escaping () -> Void) {
        let avatarPath = friendsList.avatarImagePath
        let url = URL(string: avatarPath)
        imageViewCell.kf.setImage(with: url)
        
        titleLabelCell.text = friendsList.name
        descriptionLabelCell.text = friendsList.massadge
        self.completion = completion
    }
    
    private func setupUi() {
        titleLabelCell.textColor = .white
        descriptionLabelCell.textColor = .lightGray
        imageViewCell.layer.cornerRadius = 40
        imageViewCell.layer.borderWidth = 1
        imageViewCell.layer.borderColor = UIColor.black.cgColor
        imageViewCell.clipsToBounds = true
    }
    
    @IBAction func pressImageButton(_ sender: Any) {
        UIView.animate(withDuration: 3) { [weak self] in
            self?.imageViewCell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        } completion: { _ in
            UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: []) {[weak self] in
                self?.imageViewCell.transform = .identity
            } completion: {[weak self] _ in
                self?.completion?()
            }
        }
    }
}
