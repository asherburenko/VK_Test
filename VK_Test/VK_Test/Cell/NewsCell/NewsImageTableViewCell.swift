//
//  NewsImageTableViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 30.05.2022.
//

import UIKit

class NewsImageTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImsgeView: UIImageView! = {
        let newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        return newsImageView
    }()
    
    static let identifier = "NewsImageTableViewCellID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImsgeView.image = nil
    }
    
    func setDataNewsImage(news: NewsRealm) {
        let image = news.photo
        let url = URL(string: image)
        newsImsgeView.kf.setImage(with: url)
    }
    
    private func setConstraints() {

        contentView.addSubview(newsImsgeView)

        let topConstraint = newsImsgeView.topAnchor.constraint(equalTo: contentView.topAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            newsImsgeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newsImsgeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            newsImsgeView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        topConstraint.priority = .init(999)
    }

}
