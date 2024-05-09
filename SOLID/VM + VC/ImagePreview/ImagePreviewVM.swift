//
//  ImagePreviewCM.swift
//  SOLID
//
//  Created by Luka Gujejiani on 09.05.24.
//

import Foundation

class ImagePreviewVM {
    var cachedImages: [URL: Data] = [:]
    var passedContentOffset: Int?
    var pictures: [PhotosModelElement] = []
    var picturesCount: Int = 0

    init(previewData: ImagePreviewData) {
      self.pictures = previewData.pictures
      self.picturesCount = previewData.picturesCount
      self.cachedImages = previewData.cachedImages
      self.passedContentOffset = previewData.passedContentOffset
    }
    
    var onPicturesUpdated: (() -> Void)?
}

struct ImagePreviewData {
  let pictures: [PhotosModelElement]
  let picturesCount: Int
  let cachedImages: [URL: Data]
  let passedContentOffset: Int
}