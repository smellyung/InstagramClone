import UIKit
import Firebase

struct PostService {

    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // note: upload image first to firebase so that we can use the firestore url of that image
        // then use it to create post data
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String: Any] = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageUrl": imageUrl,
                "ownerUid": uid,
                "ownerImageUrl": user.profileImageUrl,
                "ownerUsername": user.username
            ]

            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }

    }

    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }

            let posts = documents.map {
                Post(postId: $0.documentID, dictionary: $0.data())
            }

            completion(posts)
        }
    }
}
