import UIKit
import Firebase

class FeedController: UICollectionViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helpers

    func configureUI() {
        collectionView.backgroundColor = .white

        // TODO: find a way to get identifier programatically
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        collectionView.dataSource = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(handleLogout)
        )

        navigationItem.title = "Feed"
    }

    // MARK: - Actions

    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let viewModel = LoginViewModel()
            let controller = LoginController(viewModel: viewModel)
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
        return 10
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        // memory management system that queues and dequeues cells as they appear on/disappear off screen
        // reuseIdentifier helps that process
        // if cell with identifier has been displayed before
        // just grabs from the cache instead of creating a new cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
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
