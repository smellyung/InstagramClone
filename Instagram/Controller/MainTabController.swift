import UIKit
import Firebase

class MainTabController: UITabBarController {

    // should MainTabController also have a VM to send this info to VC?
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
//        logout()
    }

    // MARK: - API

    private func fetchUser() {
        UserService.fetchUser { user in
            print("current user from ProfileVM: \(user)")
            self.user = user
        }
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let viewModel = LoginViewModel()
                let controller = LoginController(viewModel: viewModel)
                controller.delegate = self
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
        } else {
            // initial fetch
            fetchUser()
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }

    // MARK: - Helpers

    func configureViewControllers(withUser user: User) {
        view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()

        // TODO: setup using images progrmatically
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())

        let profileViewModel = ProfileViewModel(user: user)
        let profile = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "profile_unselected"),
            selectedImage: #imageLiteral(resourceName: "profile_selected"),
            rootViewController: ProfileController(viewModel: profileViewModel)
        )

        viewControllers = [feed, search, imageSelector, notifications, profile]

        tabBar.tintColor = .black
    }

    func templateNavigationController(
        unselectedImage: UIImage,
        selectedImage: UIImage,
        rootViewController: UIViewController
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        print("DEBUG: Auth did complete. Fetch user and update here...")
        self.dismiss(animated: true, completion: nil)
        self.fetchUser()
    }
}
