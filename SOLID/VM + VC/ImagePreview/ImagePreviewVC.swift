import Foundation
import UIKit

// MARK: - Image Preview VC
class ImagePreviewVC: UIViewController {
    
    var viewModel: ImagePreviewVM!

    init(viewModel: ImagePreviewVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("Received Preview Data:")
        print("Pictures Count: \(viewModel.picturesCount)")
        print("Cached Images Count: \(viewModel.cachedImages.count)")
        print("Passed Content Offset: \(viewModel.passedContentOffset as Any)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(PreviewCollectionCell.self, forCellWithReuseIdentifier: PreviewCollectionCell.reuseIdentifier)
        return collectionView
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PhotosModelElement>!
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, PhotosModelElement>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reloadData()
        cellData()
        updateSnapshot()
        
        viewModel.onPicturesUpdated = { [weak self] in
            self?.updateSnapshot()
        }
    }
    
    // MARK: - UISetup
    func setupUI() {
        
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .red
        
        view.addSubview(myCollectionView)
        
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            myCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        self.view.addSubview(myCollectionView)
        
        myCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    internal func reloadData() {
        viewModel.onPicturesUpdated = { [weak self] in
            DispatchQueue.main.async {
                print("onPicturesUpdated closure called. Reloading data...")
                self?.myCollectionView.reloadData()
                print("We have \(self?.viewModel.picturesCount ?? 0) pictures)")
            }
        }
    }
}

