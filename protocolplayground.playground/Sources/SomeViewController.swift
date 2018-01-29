import UIKit

// An example view controller, and convenience methods to embed it in tabs or a nav 

public class SomeViewController: UIViewController {
  
  lazy var label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    self.view.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
      label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
      label.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
    ])
    return label
  }()
  
  convenience init(text: String) {
    self.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = .white
    self.label.text = text
  }
  
  public convenience init() {
    self.init(text: "SomeViewController, no parent VC")
  }
  
  public static func inNavController() -> UINavigationController {
    let root = SomeViewController(text: "SomeViewController, in a UINavigationController")
    root.title = "In Nav"
    let navController = UINavigationController(rootViewController: root)
    return navController
  }
  
  private static func tabBarWithFirst(_ vc1: UIViewController) -> UITabBarController {
    vc1.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
    let vc2 = AnotherViewController()
    vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 2)
    let tabBar = UITabBarController()
    tabBar.viewControllers = [ vc1, vc2 ]
    return tabBar
  }
  
  public static func inTabBarController() -> UITabBarController {
    return self.tabBarWithFirst(SomeViewController(text: "SomeViewController, the first VC in a UITabBarController"))
  }
  
  public static func inNavControllerInTabBarController() -> UITabBarController {
    let root = SomeViewController(text: "SomeViewController in a UINavigationController, which is in turn the first VC of a UITabBarController")
    root.title = "In Nav In Tab"
    let nav = UINavigationController(rootViewController: root)
    return self.tabBarWithFirst(nav)
  }
  
}
