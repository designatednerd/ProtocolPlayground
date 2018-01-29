import UIKit

// Another View Controller that is clearly different from Some View Controller

public class AnotherViewController: UIViewController {
  
  public lazy var label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 20)
    label.textColor = .white
    self.view.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
      label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
      label.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
      ])
    
    return label
  }()
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
    
    self.view.backgroundColor = .red
    self.label.text = "Another View Controller"
  }
}

