import Foundation

// Some basic code representing a network call

public struct UserDetails {
  public let name: String
  public let username: String
}

public struct Network {
  
  public static func fetchUserDetails(failureCompletion: @escaping (Error) -> Void,
                               successCompletion: @escaping (UserDetails) -> Void) {
    // Shhh, don't tell anyone we're not actually hitting the network...
    _ = GCDConvenience.async {
      let details = UserDetails(name: "Ellen", username: "designatednerd")
      successCompletion(details)
    }
  }
}
