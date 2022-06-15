//
//  GalleryCollectionViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 27.02.2022.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fotoImageView: UIImageView!
    
    static let identifier = "GalleryCollectionViewCellID"
    
    func configure(image: UIImage?) {
        fotoImageView.image = image
    }
    
    func configureURL(url: String) {
        let url = URL(string: url)
        fotoImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fotoImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
