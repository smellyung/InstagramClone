import UIKit

class ProfileController: UICollectionViewController {
    // MARK: - Properties

    var viewModel: ProfileViewModel
    
    // MARK: - Lifecycle

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel

        super.init(collectionViewLayout: UICollectionViewFlowLayout())

        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()

        viewModel.checkIfIsFollowed()
        viewModel.fetchUserStats()
        viewModel.fetchPosts()
    }

    // MARK: - Helpers

    func configureCollectionView() {
        navigationItem.title = viewModel.user.username
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        collectionView.register(
            ProfileHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeader.reuseIdentifier
        )
    }
}


// MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCell.reuseIdentifier,
            for: indexPath
        ) as! ProfileCell

        let post = viewModel.posts[indexPath.row]
        let imageURL = URL(string: post.imageUrl)

        cell.postImageView.sd_setImage(with: imageURL)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeader.reuseIdentifier,
            for: indexPath
        ) as! ProfileHeader

        let user = viewModel.user
        header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self

        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Post is \(viewModel.posts[indexPath.row].caption)")

    }
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
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        print("DEBUG: Handle action in controller")

        if user.isCurrentUser {
            print("DEBUG: Show edit profile")
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { (error) in
                // TODO: write func to update user in vm instead of directly setting it
                self.viewModel.user.isFollowed = false
            }
        } else {
            UserService.follow(uid: user.uid) { (error) in
                // TODO: write func to update user in vm instead of directly setting it
                self.viewModel.user.isFollowed = true
            }
        }
    }
}
