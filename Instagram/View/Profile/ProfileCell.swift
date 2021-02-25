import UIKit

class ProfileCell: UICollectionViewCell {

    // MARK: - Properties

    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    static let reuseIdentifier = "ProfilCellReuseIdentifier"

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .lightGray

        addSubviewAndFill(view: postImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
}
