import Foundation

protocol SearchViewModelDelegate: class {
    func searchViewModelDidUpdate()
}

class SearchViewModel {

    weak var delegate: SearchViewModelDelegate?

    // this gets mutated when searching
    private(set) var users: [User] = [User]() {
        didSet {
            self.delegate?.searchViewModelDidUpdate()
        }
    }

    // this stores the full list of users and doesn't mutate
    private var originalUsers: [User] = [User]()

    // MARK: - API

    func load() {
        fetchUsers()
    }

    func search(for text: String) {
        if text == "" {
            // reset to original users list
            users = originalUsers
        } else {
            // filter originalUsers
            users = originalUsers.filter { $0.username.contains(text) || $0.fullname.lowercased().contains(text) }
        }
    }

    // MARK: - Helpers

    private func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.originalUsers = users
        }
    }

}
