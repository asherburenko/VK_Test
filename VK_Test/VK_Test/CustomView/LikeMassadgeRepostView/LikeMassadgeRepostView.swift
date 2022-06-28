//
//  LikeMassadgeRepostView.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit

class LikeMassadgeRepostView: UIView {
    
    
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var repoostImageView: UIImageView!
    @IBOutlet weak var repostLabel: UILabel!
    @IBOutlet weak var viewsImageView: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    
    var likeCount = 0
    var messageCount = 0
    var repostCount = 0
    var viewsCount = 0
    var likePressed = false
    var messagePressed = false
    var repostPressed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadFromXIB() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: "LikeMassadgeRepostView", bundle: bundle)
        guard let view = xib.instantiate(withOwner: self, options: nil).first as? UIView else {return UIView()}
        return view
    }
    
    
    func stateLike(isFilled: Bool) {
        var likeImage = UIImage(systemName: "heart")
        if isFilled {
            likeImage = UIImage(systemName: "heart.fill")
        }
        self.likeImageView.image = likeImage
    }
    
    func stateMassage(isFilled: Bool) {
        var messageImage = UIImage(systemName: "message")
        if isFilled {
            messageImage = UIImage(systemName: "message.fill")
        }
        self.messageImageView.image = messageImage
    }
    
    func stateRepost(isFilled: Bool) {
        var repostImage = UIImage(systemName: "arrowshape.turn.up.right")
        if isFilled {
            repostImage = UIImage(systemName: "arrowshape.turn.up.right.fill")
        }
        self.repoostImageView.image = repostImage
    }

    @IBAction func clearButtonLike(_ sender: UIButton) {
        likePressed = !likePressed
        stateLike(isFilled: likePressed)
        
        if likePressed {
            UIView.transition(with: likeLabel, duration: 3, options: [.transitionFlipFromLeft]) {[weak self] in
                self?.likeCount += 1
            } completion: { _ in
                
            }
        } else {
            UIView.transition(with: likeLabel, duration: 3, options: [.transitionFlipFromLeft]) {[weak self] in
                self?.likeCount -= 1
            } completion: { _ in
                
            }
        }
        likeLabel.text = String(self.likeCount)
    }
    @IBAction func clearButtonMessage(_ sender: UIButton) {
    }
    @IBAction func clearButtonRepost(_ sender: UIButton) {
    }
}
