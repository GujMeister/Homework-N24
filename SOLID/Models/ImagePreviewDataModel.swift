//
//  ImagePreviewDataModel.swift
//  SOLID
//
//  Created by Luka Gujejiani on 09.05.24.
//

import Foundation

struct ImagePreviewData {
  let pictures: [PhotosModelElement]
  let picturesCount: Int
  let cachedImages: [URL: Data]
  let passedContentOffset: IndexPath
}
