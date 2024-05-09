//
//  GalleryVC + CollectionView .swift
//  SOLID
//
//  Created by Luka Gujejiani on 08.05.24.
//

import Foundation
import UIKit

extension GalleryVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.picturesCount
    }
    
    // MARK: - Diffable Data source
    func cellData() {
        dataSource = UICollectionViewDiffableDataSource<Section, PhotosModelElement>(collectionView: collectionView) { (collectionView, indexPath, photoModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
            
            if let urlString = photoModel.urls?.regular, let url = URL(string: urlString) {
                if let cachedImageData = self.viewModel.cachedImages[url] {
                    if let cachedImage = UIImage(data: cachedImageData) {
                        cell.imageView.image = cachedImage
                    } else {
                        cell.imageView.image = UIImage(named: "placeholder")
                    }
                } else {
                    cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
                }
            } else {
                cell.imageView.image = UIImage(named: "placeholder")
            }
            
            return cell
        }
        viewModel.onPicturesUpdated = { [weak self] in
            self?.updateSnapshot()
        }
    }
    
    func updateSnapshot() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, PhotosModelElement>()
        currentSnapshot.appendSections([.first])
        currentSnapshot.appendItems(viewModel.pictures)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        return CGSize(width: width/4 - 1, height: width/4 - 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        navigateToPreview(index: indexPath)
    }
}

