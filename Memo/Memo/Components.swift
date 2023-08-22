import UIKit

extension UIImage {
    func customImageView(_ view: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImageView {
        let imageView = UIImageView(image: self)
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        imageView.center = view.center
        view.addSubview(imageView)
        return imageView
    }
}

extension UIButton {
    func homeButton(title: String, target: Any?, action: Selector) -> UIButton {
        let homeButton = UIButton(type: .custom)
        homeButton.backgroundColor = UIColor.systemPink
        homeButton.setTitle(title, for: .normal)
            
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.contentVerticalAlignment = .center
        homeButton.contentHorizontalAlignment = .center
        
        homeButton.addTarget(target, action: action, for: .touchUpInside)
            
        return homeButton
    }
}
