//
//  NewsTextTableViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit

class NewsTextTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUi()
    }
    
    func setDataNewsText(news: NewsRealm) {
        newsTextLabel.text = news.text
    }
    
    private func setupUi() {
        newsTextLabel.backgroundColor = .darkGray
        newsTextLabel.textColor = .white
    }
}
