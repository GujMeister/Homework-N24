//
//  GalleryVM.swift
//  SOLID
//
//  Created by Luka Gujejiani on 08.05.24.
//

import Foundation
import SimpleNetworking
import SDWebImage

protocol GalleryVCDelegate {
  func updateCollectionView()
}

class GalleryVM {
    // MARK: - Properties
    
    var pictures: [PhotosModelElement] = [] {
        didSet { onPicturesUpdated?() }
    }
    
    var picturesCount: Int = 0 {
        didSet { onPicturesCountUpdated?() }
    }

    var onPicturesUpdated: (() -> Void)?
    var onPicturesCountUpdated: (() -> Void)?
    var onPhotoSelected: (([URL: Data], IndexPath) -> Void)?
    
//    var cachedImages: [URL: UIImage] = [:]
    var cachedImages: [URL: Data] = [:]
    
    // MARK: - Functions
    public func didLoad() {
        fetchPictures()
    }

    private func fetchPictures() {
        WebService().fetchData(from: "https://api.unsplash.com/photos/?client_id=9eJMaMVPl50fKO8ePj8WYN5eB0EenW141dxsyZUs8Sg", resultType: PhotosModel.self) { [weak self] result in
            switch result {
            case .success(let response):
                if !response.isEmpty {
                    self?.pictures = response
                    self?.picturesCount = response.count
                    print("✅ Pictures fetched ✅")
                    response.forEach { photo in
                        if let urlString = photo.urls?.regular, let url = URL(string: urlString) {
                            // Check if image is not already cached
                            if self?.cachedImages[url] == nil {
                                // Use SDWebImage to fetch image data
                                SDWebImageDownloader.shared.downloadImage(with: url) { (image, data, error, _) in
                                    if let imageData = data {
                                        self?.cachedImages[url] = imageData
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print("Response is empty.")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }

}
