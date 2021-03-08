import UIKit
import Firebase
import YPImagePicker

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
        self.delegate = self

        // TODO: setup using images progrmatically
        let feedViewModel = PostViewModel()
        let feed = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "home_unselected"),
            selectedImage: #imageLiteral(resourceName: "home_selected"),
            rootViewController: FeedController(viewModel: feedViewModel)
        )

        let searchViewModel = SearchViewModel()
        let search = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "search_unselected"),
            selectedImage: #imageLiteral(resourceName: "search_selected"),
            rootViewController: SearchController(viewModel: searchViewModel)
        )

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

    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { (items, _) in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }

                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen

                self.present(nav, animated: false, completion: nil)
            }
        }
    }
}

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        print("DEBUG: Auth did complete. Fetch user and update here...")
        self.dismiss(animated: true, completion: nil)
        self.fetchUser()
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)

        if index == 2 {
            var config = YPImagePickerConfiguration()

            // setup picker
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1

            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)

            didFinishPickingMedia(picker)
        }

        return true
    }
}

// MARK: - UploadPostControllerDelegate

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)

        guard let feedNav = viewControllers?.first as? UINavigationController,
              let feed = feedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresh()
    }
}
