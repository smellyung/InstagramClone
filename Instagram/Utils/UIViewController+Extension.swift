import UIKit

extension UIViewController {
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1] // gradient starts at top end at bottom
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
}
