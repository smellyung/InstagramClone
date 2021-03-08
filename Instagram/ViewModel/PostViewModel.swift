import Foundation

protocol PostViewModelDelegate: class {
    func postViewModelDidUpdate(_ postViewModel: PostViewModel)
}

class PostViewModel {

    weak var delegate: PostViewModelDelegate?

    var posts = [Post]() {
        didSet {
            self.delegate?.postViewModelDidUpdate(self)
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts { posts in
            self.posts = posts
        }
    }
}
