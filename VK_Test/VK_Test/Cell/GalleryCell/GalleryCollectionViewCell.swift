//
//  GalleryCollectionViewCell.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 27.02.2022.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fotoImageView: UIImageView!
    
    func configure(image: UIImage?) {
        fotoImageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fotoImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
