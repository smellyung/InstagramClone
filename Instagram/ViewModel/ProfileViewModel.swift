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

    var posts: [Post] = [Post]() {
        didSet {
            self.delegate?.profileViewModelDidUpdate(self)
        }
    }

    init(user: User) {
        self.user = user
    }

    func checkIfIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
            self.user.isFollowed = isFollowed
        }
    }

    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats

            print("DEBUG: Stats: \(stats)")
        }
    }

    func fetchPosts() {
        PostService.fetchPost(forUser: user.uid) { posts in
            self.posts = posts
            self.delegate?.profileViewModelDidUpdate(self)
        }
    }
}
