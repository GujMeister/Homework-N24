//
//  Junk Code.swift
//  SOLID
//
//  Created by Luka Gujejiani on 09.05.24.
//

import Foundation


//
//    func fetchPictures() {
//      WebService().fetchData(from: "https://api.unsplash.com/photos/?client_id=9eJMaMVPl50fKO8ePj8WYN5eB0EenW141dxsyZUs8Sg", resultType: PhotosModel.self) { [weak self] result in
//        switch result {
//        case .success(let response):
//          if !response.isEmpty {
////            self?.pictures = response
////            self?.picturesCount = response.count
//
//            // Cache images upon fetching (optional placeholder)
//            for photo in response {
//              if let urlString = photo.urls?.regular {
//                self?.cacheImage(urlString: urlString) // Download and cache image
//              }
//            }
//            print("✅ Pictures fetched ✅")
//          } else {
//            print("Response is empty.")
//          }
//        case .failure(let error):
//          print("Error fetching data: \(error)")
//        }
//      }
//    }
//
//    private func cacheImage(urlString: String) {
//      guard !isDownloadingImage else { return } // Prevent concurrent downloads
//      isDownloadingImage = true
//      guard let url = URL(string: urlString) else { return }
//
//      // Check cache first
//      if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
//        // Use cached image
//        print("✅ Using cached image for \(urlString)")
//        // (Optional) Update UI with cached image here (consider using a completion handler)
//      } else {
//        // Download and cache image
//        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
//          guard let self = self, let data = data, error == nil else {
//            self?.isDownloadingImage = false // Reset flag on error
//            return
//          }
//          if let image = UIImage(data: data) {
//            self.imageCache.setObject(image, forKey: NSString(string: urlString))
//            print("✅ Downloaded and cached image for \(urlString)")
//          }
//            self.isDownloadingImage = false // Reset flag on success
//          // Trigger collection view update after download (optional)
//          DispatchQueue.main.async {
//              self.delegate?.updateCollectionView() // Update collection view if needed
//          }
//        }.resume()
//      }
//    }
//




//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
//
//        let photoModel = viewModel.pictures[indexPath.row].urls?.regular
//
//        cell.imageView.setImage(with: URL(string: photoModel ?? "Nuthn"))
//
//        return cell
//    }



//    func cellData() {
//        dataSource = UICollectionViewDiffableDataSource<Section, PhotosModelElement>(collectionView: collectionView) { (collectionView, indexPath, photoModel) -> UICollectionViewCell? in
//          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
//
//            if let urlString = photoModel.urls?.regular, let url = URL(string: urlString) {
//                if let cachedImage = self.viewModel.cachedImages[url] {
//                    cell.imageView.image = cachedImage // Use cached image if available
//                } else {
//                    // Use placeholder or loading indicator until image is loaded
//                    cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
//                }
//            } else {
//                // Use placeholder or loading indicator for broken URLs
//                cell.imageView.image = UIImage(named: "placeholder")
//            }
//
//          return cell
//        }
//
//        viewModel.onPicturesUpdated = { [weak self] in
//          self?.updateSnapshot()
//        }
//    }
