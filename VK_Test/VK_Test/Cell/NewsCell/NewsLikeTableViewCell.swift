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
    
    var likeCount = 0
    var messageCount = 0
    var repostCount = 0
    var viewsCount = 0
    var likePressed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
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
            } completion: { _ in
                
            }
        } else {
            UIView.transition(with: likeLabel, duration: 1, options: [.transitionFlipFromLeft]) {[weak self] in
                self?.likeCount -= 1
            } completion: { _ in
                
            }
        }
        likeLabel.text = String(self.likeCount)
    }
}

extension NewsLikeTableViewCell {
    func setDataLike (like: Int, message: Int, repost: Int, views: Int) {
        self.likeCount = like
        self.messageCount = message
        self.repostCount = repost
        self.viewsCount = views
        
        self.likeLabel.text = String(self.likeCount)
        self.messageLabel.text = String(self.messageCount)
        self.repostLabel.text = String(self.repostCount)
        self.viewsLabel.text = String(self.viewsCount)
    }
}
