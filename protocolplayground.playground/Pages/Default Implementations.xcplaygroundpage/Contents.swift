//: ## Playground for Protocols All The Way Down

import UIKit
import PlaygroundSupport

/*:
 ### Initial Protocol Definition

What are the things that something conforming to htis protocol is required to do?
*/
protocol HUDShowing {
  func showHUD(in view: UIView,
               title: String?,
               animated: Bool) -> HUD
  
  func hideHUD(_ hud: HUD,
               animated: Bool)
}

/*:
 ### Default Protocol Extension

By default, what should something conforming to this protocol do in order to fulfill requirements of the protocol?
 
If something declared in the protocol isn't implemented here, anything that conforms to the protocol must provide an implementation.
*/
extension HUDShowing {
  
  func showHUD(in view: UIView,
               title: String?,
               animated: Bool = true) -> HUD {
    let hud = HUD(text: title)
    hud.frame = view.bounds
    view.addSubview(hud)
    hud.show(animated: animated)
    
    return hud
  }
  
  func hideHUD(_ hud: HUD,
               animated: Bool = true) {
    hud.hide(animated: animated, completion: {
      hud.removeFromSuperview()
    })
  }
}

/*:
 ### Adding a protocol extension to a default type

Allows everything directly or indirectly inheriting from this type to use the default implementation.
*/
extension UIView: HUDShowing {

  @discardableResult
  func showHUD(title: String?,
               animated: Bool = true) -> HUD {
    return self.showHUD(in: self,
                        title: title,
                        animated: animated)
  }

  func hideHUD(animated: Bool = true) {
    guard let hud = HUD.hud(in: self) else { return }

    self.hideHUD(hud, animated: animated)
  }
}

/*:
 ### Using the extended functionality in another default implementation

Now when making a view controller which conforms to UIViewController, you can use the same convenience methods as above.
 */

extension HUDShowing where Self: UIViewController {
  
  var viewToShowHUDIn: UIView {
    if let tabBar = self.tabBarController {
      return tabBar.view
    } else if let nav = self.navigationController {
      return nav.view
    } else {
      return self.view
    }
  }

  @discardableResult
  func showHUD(title: String?,
               animated: Bool = true) -> HUD {
    return self.viewToShowHUDIn.showHUD(title: title, animated: animated)
  }

  func hideHUD(animated: Bool = true) {
    self.viewToShowHUDIn.hideHUD(animated: animated)
  }
}

/*:
 ### Another protocol definition
*/

protocol UserDetailsFetching {

  func handleError(_ error: Error)

  func fetchUserDetails(successCompletion: @escaping (UserDetails) -> Void)
}

/*:
 ### Default definition for multiple conditions

 Anything taking wishing to take advantage of these implementations must conform to all requirements: In this case it must be a UIViewController which already conforms to HUDShowing

 This allows you to use protocols like building blocks really easily.
*/
extension UserDetailsFetching where Self: UIViewController, Self: HUDShowing {

  private func showErrorAlert(for error: Error) {
    let alert = UIAlertController(title: "Error fetching details",
                                  message: error.localizedDescription,
                                  preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default))

    self.present(alert, animated: true)
  }

  func handleError(_ error: Error) {
    self.showErrorAlert(for: error)
  }

  func fetchUserDetails(successCompletion: @escaping (UserDetails) -> Void) {
    self.showHUD(title: "Fetching details...")
    Network.fetchUserDetails(failureCompletion: { [weak self] error in
      self?.hideHUD()
      self?.handleError(error)
    }, successCompletion: { [weak self] details in
      self?.hideHUD()
      successCompletion(details)
    })
  }
}

/*
 ### Adding conformances to view controllers which are in the `Sources` folder
 */

extension SomeViewController: HUDShowing { }
extension AnotherViewController: HUDShowing { }
extension AnotherViewController: UserDetailsFetching { }

/*
 ### Setting up various views for animation
 */

let aPlainView = UIView(frame: CGRect(x: 0,
                                      y: 0,
                                      width: 400,
                                      height: 400))
aPlainView.backgroundColor = .white

let someView = SomeView()

let vc = SomeViewController()
let nav = SomeViewController.inNavController()
let tabBar = SomeViewController.inTabBarController()
let tabWithNav = SomeViewController.inNavControllerInTabBarController()

guard let inNav = nav.topViewController as? SomeViewController else {
  fatalError("ERROR: Top VC is not SomeViewController")
}
guard let inTab = tabBar.viewControllers?.first as? SomeViewController else {
  fatalError("ERROR: First VC is not SomeViewController")
}
guard let inNavInTab = (tabWithNav.viewControllers?.first as? UINavigationController)?.topViewController as? SomeViewController else {
  fatalError("Top VC in nav in tab is not SomeViewController")
}
guard let another = tabWithNav.viewControllers?.last as? AnotherViewController else {
  fatalError("Last VC is not AnotherViewController")
}

/*
 ### Actual animation!
 
 Uses some convenience methods on GCD (available in `Sources` if you're curious) to make it a bit clearer to chain all this in a readable fashinon. 
 
 Make sure you've got the live view showing so you can see all this in action.
 */

PlaygroundPage.current.liveView = aPlainView

GCDConvenience.async {
    aPlainView.showHUD(title: "In a plain view with the UIView extension")
  }.next {
    aPlainView.hideHUD()
  }.next {
    PlaygroundPage.current.liveView = someView
  }.next {
    someView.showHUD(title: "In a conforming UIView subclass")
  }.next {
    someView.hideHUD()
  }.next {
    PlaygroundPage.current.liveView = vc
  }.next {
    vc.showHUD(title: "In a conforming UIVC subclass")
  }.next {
    vc.hideHUD()
  }.next {
    PlaygroundPage.current.liveView = nav
  }.next {
    inNav.showHUD(title: "In a conforming UIVC subclass in a UINavigationController")
  }.next {
    inNav.hideHUD()
  }.next {
    PlaygroundPage.current.liveView = tabBar
  }.next {
    inTab.showHUD(title: "In a conforming UIVC subclass in a UITabBarController")
  }.next {
    inTab.hideHUD()
  }.next {
    PlaygroundPage.current.liveView = tabWithNav
  }.next {
    inNavInTab.showHUD(title: "In a conforming UIVC sublclass in a UINavigation controller in a UITabBarController")
  }.next {
    inNavInTab.hideHUD()
  }.next {
    tabWithNav.selectedViewController = another
  }.next {
    another.fetchUserDetails { userDetails in
      another.label.text = "User Name: \(userDetails.name)\nUser handle: @\(userDetails.username)"
    }
  }.finally(after: 5) {
    PlaygroundPage.current.finishExecution()
  }

//: [Some Pitfalls >](@next)
