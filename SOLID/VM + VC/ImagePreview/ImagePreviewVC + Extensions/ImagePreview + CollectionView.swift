//
//  ImagePreviewCollectionViewCell.swift
//  SOLID
//
//  Created by Luka Gujejiani on 09.05.24.
//

import UIKit

extension ImagePreviewVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - CollectionView Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.picturesCount
    }
    
    func cellData() {
        dataSource = UICollectionViewDiffableDataSource<Section, PhotosModelElement>(collectionView: myCollectionView) { (collectionView, indexPath, photoModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionCell.reuseIdentifier, for: indexPath) as! PreviewCollectionCell
            
            if let urlString = photoModel.urls?.regular, let url = URL(string: urlString) {
                if let cachedImageData = self.viewModel.cachedImages[url] {
                    if let cachedImage = UIImage(data: cachedImageData) {
                        cell.imgView.image = cachedImage
                    } else {
                        cell.imgView.image = UIImage(named: "placeholder")
                    }
                } else {
                    cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
                }
            } else {
                cell.imgView.image = UIImage(named: "placeholder")
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
    
    // MARK: - CollectionView Delegate Flow Layout Methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = myCollectionView.frame.size
        
        flowLayout.invalidateLayout()
        
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = myCollectionView.contentOffset
        let width  = myCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
}
