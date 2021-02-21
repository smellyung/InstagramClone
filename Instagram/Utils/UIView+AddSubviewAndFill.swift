import UIKit

extension UIView {
    func addSubviewAndFill(
      view: UIView,
      leading: CGFloat = 0,
      top: CGFloat = 0,
      trailing: CGFloat = 0,
      bottom: CGFloat = 0
    ) {
      view.translatesAutoresizingMaskIntoConstraints = false
      addSubview(view)

      view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading).isActive = true
      view.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
      view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailing).isActive = true
      view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom).isActive = true
    }

    func addSubviewAndFill(
      view: UIView,
      margin: CGFloat
    ) {
      addSubviewAndFill(
        view: view,
        leading: margin,
        top: margin,
        trailing: margin,
        bottom: margin
      )
    }

    func addSubviewAndFill(
      view: UIView,
      horizontal: CGFloat = 0,
      vertical: CGFloat = 0
    ) {
      addSubviewAndFill(
        view: view,
        leading: horizontal,
        top: vertical,
        trailing: horizontal,
        bottom: vertical
      )
    }

    func addSubviewAndFill(
      view: UIView,
      top: CGFloat,
      horizontal: CGFloat,
      bottom: CGFloat
    ) {
      addSubviewAndFill(
        view: view,
        leading: horizontal,
        top: top,
        trailing: horizontal,
        bottom: bottom
      )
    }

    func addSubviewAndFill(
      view: UIView,
      insets: UIEdgeInsets
    ) {
      addSubviewAndFill(
        view: view,
        leading: insets.left,
        top: insets.top,
        trailing: insets.right,
        bottom: insets.bottom
      )
    }

}
