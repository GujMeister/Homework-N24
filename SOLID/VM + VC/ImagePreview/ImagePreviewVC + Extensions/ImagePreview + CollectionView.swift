//
//  ImagePreviewCollectionViewCell.swift
//  SOLID
//
//  Created by Luka Gujejiani on 09.05.24.
//

import UIKit

extension ImagePreviewVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pictures.count
    }
    
    func cellData() {
        dataSource = UICollectionViewDiffableDataSource<Section, PhotosModelElement>(collectionView: previewCollectionView) { (collectionView, indexPath, photoModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionCell.reuseIdentifier, for: indexPath) as! PreviewCollectionCell
            
            if let urlString = photoModel.urls?.regular, let url = URL(string: urlString) {
                if let cachedImageData = self.viewModel.cachedImages[url] {
                    if let cachedImage = UIImage(data: cachedImageData) {
                        print("Setting image using cachedImage")
                        print("🟢\(indexPath)🟢")
                        cell.imageView.image = cachedImage
                        
                    } else {
                        print("Setting placeholder image")
                        cell.imageView.image = UIImage(named: "placeholder")
                    }
                } else {
                    print("Setting image using sd_setImage")
                    print("🟢\(indexPath)🟢")
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
        print("🔴 Update snapshot called 🔴")
    }
    
    // MARK: - Delegate Flow Layout Methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = previewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = previewCollectionView.frame.size
        flowLayout.invalidateLayout()
        previewCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = previewCollectionView.contentOffset
        let width  = previewCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        previewCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.previewCollectionView.reloadData()
            
            self.previewCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
}
