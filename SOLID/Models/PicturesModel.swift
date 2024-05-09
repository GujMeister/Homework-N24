//
//  PicturesModel.swift
//  SOLID
//
//  Created by Luka Gujejiani on 08.05.24.
//

//   let photosModel = try? JSONDecoder().decode(PhotosModel.self, from: jsonData)

import Foundation

// MARK: - PhotosModelElement
struct PhotosModelElement: Decodable, Hashable {
    let width, height: Int?
    let description: String?
    let urls: Urls?
}

// MARK: - Urls
struct Urls: Codable, Hashable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

typealias PhotosModel = [PhotosModelElement]
