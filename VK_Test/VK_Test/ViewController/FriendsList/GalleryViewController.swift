//
//  GalleryViewController.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 27.02.2022.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    let galleryIdentifier = "galleryIdentifier"
    
    var fotoArray = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        friendsCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = .darkGray
        let imageView = UIImageView(frame: view.frame)
        
        self.view.addSubview(view)
        view.addSubview(imageView)
        let url = URL(string: fotoArray[indexPath.item])
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFit
    }
}

extension GalleryViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.width / 2 - 10)
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fotoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: galleryIdentifier, for: indexPath) as? GalleryCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configureURL(url: fotoArray[indexPath.item])
        return cell
    }
    
    
}

extension GalleryViewController {
    func registerCell() {
        friendsCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: galleryIdentifier)
    }
}
