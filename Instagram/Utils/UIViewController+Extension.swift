import UIKit
import JGProgressHUD

extension UIViewController {
    // extensions cant store properties
    static let hud = JGProgressHUD(style: .dark)

    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1] // gradient starts at top end at bottom
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }

    func showLoader(_ show: Bool) {
        view.endEditing(true)

        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
}
