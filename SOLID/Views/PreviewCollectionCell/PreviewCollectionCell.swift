//
//  c.swift
//  SOLID
//
//  Created by Luka Gujejiani on 09.05.24.
//

import Foundation
import UIKit

// MARK: - PreviewCollectionCell
class PreviewCollectionCell: UICollectionViewCell, UIScrollViewDelegate {
    
    // MARK: - Properties
    var scrollImage: UIScrollView!
    var imageView: UIImageView!
    
    static let reuseIdentifier = "PreviewCollectionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollImage = UIScrollView()
        scrollImage.delegate = self
        scrollImage.alwaysBounceVertical = false
        scrollImage.alwaysBounceHorizontal = false
        scrollImage.showsVerticalScrollIndicator = true
        scrollImage.flashScrollIndicators()
        
        scrollImage.minimumZoomScale = 1.0
        scrollImage.maximumZoomScale = 4.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImage.addGestureRecognizer(doubleTapGest)
        
        self.addSubview(scrollImage)
        
        // Setup image view
        imageView = UIImageView()
        scrollImage.addSubview(imageView!)
        imageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - Double Tap Zoom
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImage.zoomScale == 1 {
            scrollImage.zoom(to: zoomRectForScale(scale: scrollImage.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImage.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollImage)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollImage.frame = self.bounds
        imageView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollImage.setZoomScale(1, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
