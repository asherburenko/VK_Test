//
//  NewsLikeTableViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit

class NewsLikeTableViewCell: UITableViewCell {
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var repostLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    static let identifier = "NewsLikeTableViewCellID"
    
    var likeCount = 0
    var messageCount = 0
    var repostCount = 0
    var viewsCount = 0
    var likePressed = false
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func stateLike(isFilled: Bool) {
        var likeImage = UIImage(systemName: "heart")
        if isFilled {
            likeImage = UIImage(systemName: "heart.fill")
        }
        self.likeImageView.image = likeImage
    }
    
    @IBAction func clearButtonLike(_ sender: UIButton) {
        likePressed = !likePressed
        stateLike(isFilled: likePressed)
        
        if likePressed {
            UIView.transition(with: likeLabel, duration: 1, options: [.transitionFlipFromLeft]) {[weak self] in
                self?.likeCount += 1
            }
        } else {
            UIView.transition(with: likeLabel, duration: 1, options: [.transitionFlipFromLeft]) {[weak self] in
                self?.likeCount -= 1
            } 
        }
        likeLabel.text = String(self.likeCount)
    }
}

extension NewsLikeTableViewCell {
    func setDataLike (news: NewsRealm) {
        self.likeCount = news.likes
        self.messageCount = news.comments
        self.repostCount = news.reposts
        self.viewsCount = news.views
        
        self.likeLabel.text = String(self.likeCount)
        self.messageLabel.text = String(self.messageCount)
        self.repostLabel.text = String(self.repostCount)
        self.viewsLabel.text = String(self.viewsCount)
    }
}
