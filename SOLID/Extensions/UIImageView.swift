//
//  UIImageView.swift
//  SOLID
//
//  Created by Luka Gujejiani on 09.05.24.
//

import UIKit

extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0

    private var savedTask: URLSessionTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var savedUrl: URL? {
        get { objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        // Cancel prior task, if any
        weak var oldTask = savedTask
        savedTask = nil
        oldTask?.cancel()

        // Reset image view’s image
        self.image = placeholder

        // Allow supplying of `nil` to remove old image and then return immediately
        guard let url = url else { return }

        // Check cache
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        // Download
        savedUrl = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.savedTask = nil

            // Error handling
            if let error = error {
                // Don't bother reporting cancelation errors
                if (error as NSError).code == NSURLErrorCancelled { return }
                print(error)
                return
            }

            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("Unable to extract image")
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: url.absoluteString)

            if url == self?.savedUrl {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }

        // Save and start new task
        savedTask = task
        task.resume()
    }
}

import UIKit

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol?

    static let shared = ImageCache()

    private init() {
        // Make sure to purge cache on memory pressure
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

