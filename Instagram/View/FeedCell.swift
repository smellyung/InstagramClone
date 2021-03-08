import UIKit

let IMAGE_DIMENSIONS: CGFloat = 40

class FeedCell: UICollectionViewCell {
    static let reuseIdentifier = "FeedCellReuseIdentifier"

    // MARK: - Properties

    var post: Post? {
        didSet {
            configure()
        }
    }

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let size = CGSize(square: 3 * .baseline)
        let diameter = max(size.width, size.height)
        imageView.layer.cornerRadius = diameter / 2

        // TODO: temp stored image from assets
        imageView.image = #imageLiteral(resourceName: "venom-7")

        NSLayoutConstraint.activate([
          imageView.widthAnchor.constraint(equalToConstant: size.width),
          imageView.heightAnchor.constraint(equalToConstant: size.height),
        ])
        return imageView
    }()

    private lazy var usernameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("venom", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(didTapUsername(_:)), for: .touchUpInside)
        return button
    }()

    private var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = " 2 days ago"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()

    private lazy var actionButtonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = .baseline
        return UIStackView(arrangedSubviews: [stackView, UIView()])
    }()

    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likesLabel, captionLabel])
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        let topStack = UIStackView(arrangedSubviews: [profileImageView, usernameButton, UIView()])
        topStack.alignment = .leading
        topStack.spacing = .baseline

        let topStackContainer = UIView()
        topStackContainer.addSubviewAndFill(view: topStack, margin: .baseline)

        let actionButtonStackContainer = UIView()
        actionButtonStackContainer.addSubviewAndFill(view: actionButtonStack, margin: .baseline)

        let labelStackContainer = UIView()
        labelStackContainer.addSubviewAndFill(view: labelStack, margin: .baseline)

        let stack = UIStackView(
            arrangedSubviews: [
                topStackContainer,
                postImageView,
                actionButtonStackContainer,
                labelStackContainer
            ]
        )
        stack.axis = .vertical

        addSubviewAndFill(view: stack)

        NSLayoutConstraint.activate([
            postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc func didTapUsername(_ sender: UIControl) {
        print("tapped username")
    }

    // MARK: - Helpers

    func configure() {
        guard let post = post else { return }

        captionLabel.text = post.caption

        // move some of this to cell's own VM?
        let image = URL(string: post.imageUrl)
        postImageView.sd_setImage(with: image) // SD_WebImage auto handles caching images

        let likesLabelText = post.likes == 1 ? "\(post.likes) like" : "\(post.likes) likes"
        likesLabel.text = likesLabelText

        let userProfileImage = URL(string: post.ownerImageUrl)
        profileImageView.sd_setImage(with: userProfileImage)

        usernameButton.setTitle(post.ownerUsername, for: .normal)
    }
}

