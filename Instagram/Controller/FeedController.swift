import UIKit
import Firebase

class FeedController: UICollectionViewController {

    // MARK: - Properties

    private var viewModel: PostViewModel

    // MARK: - Lifecycle

    init(viewModel: PostViewModel) {
        self.viewModel = viewModel

        super.init(collectionViewLayout: UICollectionViewFlowLayout())

        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPosts()
        configureUI()
    }

    // MARK: - Helpers

    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        collectionView.dataSource = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(handleLogout)
        )
        navigationItem.title = "Feed"

        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }

    // MARK: - Actions

    @objc func handleRefresh() {
        viewModel.fetchPosts()
    }

    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let viewModel = LoginViewModel()
            let controller = LoginController(viewModel: viewModel)
            controller.delegate = self.tabBarController as? MainTabController

            // TODO: UserService.setUser to nil?

            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
}


// MARK: - UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
        cell.post = viewModel.posts[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width

        // TODO: - do this programatically?
        let height = width + (.baseline * 16)
        return CGSize(width: view.frame.width, height: height)
    }
}

extension FeedController: PostViewModelDelegate {
    func postViewModelDidUpdate(_ postViewModel: PostViewModel) {
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
    }
}
