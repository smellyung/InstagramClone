import Foundation

protocol ProfileViewModelDelegate: class {
    func profileViewModelDidUpdate(_ profileViewModel: ProfileViewModel)
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?

    // create func getUser() instead?
    var user: User? {
        didSet {
            self.delegate?.profileViewModelDidUpdate(self)
        }
    }

    func load() {
        fetchUser()
    }

    private func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
}
