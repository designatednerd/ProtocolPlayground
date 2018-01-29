import Foundation

// Wrappers to make GCD stuff more readable and easily chainable

public class ChainableWork {
  
  private var execute: (() -> Void)?
  private(set) var delay: TimeInterval = 0
  private var next: ChainableWork?
  
  func run() {
    execute?()
  }
  
  func complete() {
    guard let nextWork = self.next else { return }
    
    GCDConvenience.asyncWork(nextWork)
  }
  
  public func next(after seconds: TimeInterval = 2, execute: @escaping (() -> Void)) -> ChainableWork {
    
    let nextWork = ChainableWork()
    nextWork.delay = seconds
    nextWork.execute = execute
    
    self.next = nextWork

    return nextWork
  }
  
  public func finally(after seconds: TimeInterval = 2, _ execute: @escaping (() -> Void)) {
    let finalWork = ChainableWork()
    finalWork.delay = seconds
    finalWork.execute = execute
    
    self.next = finalWork
  }
}

public struct GCDConvenience {
  
  static func asyncWork(_ work: ChainableWork) {
    let deadline: DispatchTime = .now() + work.delay
    DispatchQueue.main.asyncAfter(deadline: deadline) {
      work.run()
      work.complete()
    }
  }
  
  public static func async(after seconds: TimeInterval = 2, _ execute: @escaping (() -> Void)) -> ChainableWork {
    
    let work = ChainableWork()
    let deadline: DispatchTime = .now() + seconds
    DispatchQueue.main.asyncAfter(deadline: deadline) {
      execute()
      work.complete()
    }
    
    return work
  }
}
