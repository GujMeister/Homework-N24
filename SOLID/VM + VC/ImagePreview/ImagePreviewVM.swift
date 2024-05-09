//
//  ImagePreviewCM.swift
//  SOLID
//
//  Created by Luka Gujejiani on 09.05.24.
//

import Foundation

class ImagePreviewVM {
    public var cachedImages: [URL: Data] = [:]
    public var passedContentOffset: IndexPath {
        didSet { onPassedContentOffsetUpdated?() }
    }
    public var pictures: [PhotosModelElement] = [] {
        didSet { onPicturesUpdated?() }
    }
    public var picturesCount: Int = 0

    init(previewData: ImagePreviewData) {
      self.pictures = previewData.pictures
      self.picturesCount = previewData.picturesCount
      self.cachedImages = previewData.cachedImages
      self.passedContentOffset = previewData.passedContentOffset
    }
    
    var onPicturesUpdated: (() -> Void)?
    var onPassedContentOffsetUpdated:  (() -> Void)?
}
