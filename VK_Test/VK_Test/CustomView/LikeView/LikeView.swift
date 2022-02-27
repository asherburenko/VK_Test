//
//  LikeView.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 27.02.2022.
//

import UIKit

class LikeView: UIView {
    
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    
    var count = 0
    var isHeartPressed = false
    var viewXIB: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func loadForXIB() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: "LikeView", bundle: bundle)
        guard let view = xib.instantiate(withOwner: self, options: nil).first as? UIView else {return UIView()}
        return view
    }
    
    func setup() {
        self.viewXIB = loadForXIB()
        self.viewXIB.frame = self.bounds
        self.viewXIB.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.viewXIB)
        self.bringSubviewToFront(viewXIB)
        
        counterLabel.text = String(self.count)
        heartState(isFilled: false)
    }
    
    func heartState(isFilled: Bool) {
        var heartImage = UIImage(systemName: "heart")
        if isFilled {
            heartImage = UIImage(systemName: "heart.fill")
        }
        self.heartImageView.image = heartImage
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        isHeartPressed = !isHeartPressed
        heartState(isFilled: isHeartPressed)
        
        if isHeartPressed {
            self.count += 1
        } else {
            self.count -= 1
        }
        counterLabel.text = String(self.count)
    }
}
