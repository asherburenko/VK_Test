//
//  NewsImageTableViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit

class NewsImageTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImsgeView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataNewsImage(image: String) {
        newsImsgeView.image = UIImage(named: image)
    }
    
    private func setupUi() {
  
    }
}
