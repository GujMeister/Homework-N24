import Foundation
import UIKit

// MARK: - Image Preview VC
class ImagePreviewVC: UIViewController {
    // MARK: - Properties
    var viewModel: ImagePreviewVM!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PhotosModelElement>!
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, PhotosModelElement>!

    init(viewModel: ImagePreviewVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("Received Preview Data:\n", "Pictures Count: \(viewModel.picturesCount)\n", "Cached Images Count: \(viewModel.cachedImages.count)\n", "Passed Content Offset: \(viewModel.passedContentOffset as Any)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var previewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(PreviewCollectionCell.self, forCellWithReuseIdentifier: PreviewCollectionCell.reuseIdentifier)
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cellData()
        updateSnapshot()
        setupUI()
    }

    // MARK: - UISetup
    func setupUI() {
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .black
        
        view.addSubview(previewCollectionView)
        
        previewCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            previewCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            previewCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

