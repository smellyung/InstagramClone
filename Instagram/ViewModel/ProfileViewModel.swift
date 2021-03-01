import Foundation

protocol ProfileViewModelDelegate: class {
    func profileViewModelDidUpdate(_ profileViewModel: ProfileViewModel)
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?

    // create func getUser() instead?
    var user: User {
        didSet {
            self.delegate?.profileViewModelDidUpdate(self)
        }
    }

    init(user: User) {
        self.user = user
    }
}
