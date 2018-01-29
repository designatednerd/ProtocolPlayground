import UIKit

// A basic UIView Subclass 

public class SomeView: UIView {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .green
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.backgroundColor = .green
  }
  
  public convenience init() {
    self.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 20)
    label.text = "SomeView, a subclass of UIView"
    self.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100),
      label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
      label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
    ])
  }
}
