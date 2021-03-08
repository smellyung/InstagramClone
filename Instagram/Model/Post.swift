import Firebase

struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String

    // Since we're using Firestore instead of Realtime
    // Firestore is cheaper to store more data but expensive to read
    // Realtime is expensive to store more data but cheaper to read data (tree structure)
    // so instead we are creating duplicates of data here
    let ownerImageUrl: String
    let ownerUsername: String


    init(postId: String, dictionary: [String: Any]) {
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postId = postId
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
