import UIKit

extension UIButton {
    func attributedTitle(regularText: String, boldText: String) {
        let atts: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 1, alpha: 0.87),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        let boldAtts: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 1, alpha: 0.87),
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]

        let attributedTitle = NSMutableAttributedString(string: "\(regularText) ", attributes: atts)
        attributedTitle.append(NSAttributedString(string: boldText, attributes: boldAtts))

        setAttributedTitle(attributedTitle, for: .normal)
    }

}
