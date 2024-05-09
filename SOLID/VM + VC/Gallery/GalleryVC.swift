//
//  GalleryVC.swift
//  SOLID
//
//  Created by Luka Gujejiani on 08.05.24.
//
enum Section {
    case first
}
import UIKit

class GalleryVC: UIViewController {
    
    var viewModel: GalleryVM! = GalleryVM()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PhotosModelElement>!
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, PhotosModelElement>!
    
    static let galleryLabel: UILabel = {
        let label = UILabel()
        label.text = "გალერეა"
        label.textColor = UIColor(hex: "3C79F1")
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.didLoad()
        reloadData()
        cellData()
        updateSnapshot()
        
        viewModel.onPicturesUpdated = { [weak self] in
            self?.updateSnapshot()
        }
    }
    
    // MARK: - Setup UI
    func setupUI() {
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .red
        
        view.addSubview(GalleryVC.galleryLabel)
        view.addSubview(collectionView)
        
        GalleryVC.galleryLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            GalleryVC.galleryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GalleryVC.galleryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: GalleryVC.galleryLabel.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Helper functions
    internal func reloadData() {
        viewModel.onPicturesUpdated = { [weak self] in
            DispatchQueue.main.async {
                print("onPicturesUpdated closure called. Reloading data...")
                self?.collectionView.reloadData()
                print("We have \(self?.viewModel.picturesCount ?? 0) pictures)")
            }
        }
    }
    
    func navigateToPreview(index: Int) {
        let selectedPhoto = viewModel.pictures[index]
      guard let imageUrlString = selectedPhoto.urls?.regular, let imageUrl = URL(string: imageUrlString) else { return }

        let previewData = ImagePreviewData(pictures: viewModel.pictures, picturesCount: viewModel.picturesCount, cachedImages: viewModel.cachedImages, passedContentOffset: index)
        
        print("Preview Data:")
        print("Pictures Count: \(previewData.picturesCount)")
        print("Cached Images Count: \(previewData.cachedImages.count)")
        print("Passed Content Offset: \(previewData.passedContentOffset)")

      let previewVM = ImagePreviewVM(previewData: previewData)
      let PreviewVC = ImagePreviewVC(viewModel: previewVM)
      navigationController?.pushViewController(PreviewVC, animated: true)
    }
}
    
