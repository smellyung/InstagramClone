import UIKit

class ProfileController: UICollectionViewController {
    // MARK: - Properties

    var viewModel: ProfileViewModel

    // MARK: - Initialisers

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }

    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        collectionView.register(
            ProfileHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeader.reuseIdentifier
        )
        viewModel.load()
    }
}


// MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeader.reuseIdentifier,
            for: indexPath
        ) as! ProfileHeader

        // find another way to set this?
        if let user = viewModel.user {
            header.viewModel = ProfileHeaderViewModel(user: user)
        } else {
            print("DEBUG: User not yet set...")
        }

        return header
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileController {

}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    // horizontal spacing between columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // vertical spacing between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // - 2 to account for spacing
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

extension ProfileController: ProfileViewModelDelegate {
    func profileViewModelDidUpdate(_ profileViewModel: ProfileViewModel) {
        self.collectionView.reloadData()
        self.navigationItem.title = viewModel.user?.username ?? ""
    }
}
