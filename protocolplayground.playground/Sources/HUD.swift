import UIKit

// The Heads-Up Display class to show/hide

public class HUD: UIView {
  private lazy var progressIndicator: UIActivityIndicatorView = {
    let activityIndictor = UIActivityIndicatorView()
    activityIndictor.translatesAutoresizingMaskIntoConstraints = false
    activityIndictor.activityIndicatorViewStyle = .whiteLarge
    activityIndictor.startAnimating()
    
    
    return activityIndictor
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.textColor = .white
    label.textAlignment = .center
    
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    
    self.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
      stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
    ])
    
    return stackView
  }()
  
  private func setAlpha(_ alpha: CGFloat, animated: Bool, completion: (() -> Void)? = nil) {
    let duration = animated ? 0.5 : 0
    UIView.animate(withDuration: duration, animations: {
      self.alpha = alpha
    }, completion: { _ in
      completion?()
    })
  }
  
  public static func hud(in view: UIView) -> HUD? {
    return view.subviews.first(where: { $0 is HUD }) as? HUD
  }
  
  public convenience init(text: String?) {
    self.init(frame: .zero)
    self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    self.stackView.addArrangedSubview(progressIndicator)
    self.stackView.addArrangedSubview(titleLabel)
    self.titleLabel.text = text
    self.hide(animated: false)
  }
  
  public func show(animated: Bool, completion: (() -> Void)? = nil) {
    self.setAlpha(1, animated: animated, completion: completion)
  }
  
  public func hide(animated: Bool, completion: (() -> Void)? = nil)  {
    self.setAlpha(0, animated: animated, completion: completion)
  }
}
