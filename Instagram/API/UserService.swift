import Foundation
import Firebase

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        // get current user id and fetch it from the database
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}
