import Foundation
import UIKit

struct ProfileHeaderViewModel {
    let user: User

    var fullname: String {
        return user.fullname
    }

    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }

    // TODO: move this UI related stuff out of VM
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }

        return user.isFollowed ? "Following" : "Follow"
    }

    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }

    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }

    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user.stats.followers, label: "followers")
    }

    var numberOfFollowing: NSAttributedString {
        return attributedStatText(value: user.stats.following, label: "following")
    }

    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: 5, label: "posts")
    }

    init(user: User) {
        self.user = user
    }

    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}
