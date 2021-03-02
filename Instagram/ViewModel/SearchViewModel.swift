import Foundation

protocol SearchViewModelDelegate: class {
    func searchViewModelDidUpdate()
}

class SearchViewModel {

    weak var delegate: SearchViewModelDelegate?

    var users: [User] = [User]() {
        didSet {
            self.delegate?.searchViewModelDidUpdate()
        }
    }

    func load() {
        fetchUsers()
    }

    private func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
        }
    }
}
