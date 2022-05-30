//
//  NewsTextTableViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit

class NewsTextTableViewCell: UITableViewCell {

    @IBOutlet weak var nawsTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataNewsText(text: String) {
        nawsTextLabel.text = text
    }
    
    private func setupUi() {
        nawsTextLabel.textColor = .white
    }
}
