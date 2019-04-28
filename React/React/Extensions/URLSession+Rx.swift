import Foundation
import RxSwift
import RxCocoa
extension Reactive where Base: URLSession {
  public func response(url:URL) -> Observable<(response:HTTPURLResponse,data:Data)> {
    return Observable.create({ (observer) -> Disposable in
      let task = self.base.dataTask(with: url, completionHandler: { (data, response, error) in
        guard let response = response, let data = data else {
          observer.on(.error(error ?? RxCocoaURLError.unknown))
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
          observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
          return
        }
        
        observer.on(.next((response:httpResponse,data:data)))
        observer.on(.completed)
      })
      
      task.resume()
      
      return Disposables.create {
        task.cancel()
      }
    })
  }
  
  public func response<T:Codable>(url:URL,
                                  type:T.Type) -> Observable<(json:T,response:HTTPURLResponse)> {
    return Observable.create({ (observer) -> Disposable in
      let task = self.base.dataTask(with: url, completionHandler: { (data, response, error) in
        
        guard let response = response, let data = data else {
          observer.on(.error(error ?? RxCocoaURLError.unknown))
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
          observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
          return
        }
        
        do {
          let jsonData = try JSONDecoder().decode(type, from: data)
          observer.on(.next((json:jsonData,response:httpResponse)))
        } catch {
          observer.on(.error(error))
        }
        observer.on(.completed)
      })
      task.resume()
      
      return Disposables.create {
        task.cancel()
      }
  })
}
  public func response<T:Codable>(url:URL,
                                  type:T.Type) -> Observable<T> {
    return Observable.create({ (observer) -> Disposable in
      let task = self.base.dataTask(with: url, completionHandler: { (data, response, error) in
        
        guard let data = data else {
          observer.on(.error(error ?? RxCocoaURLError.unknown))
          return
        }
        
        do {
          let jsonData = try JSONDecoder().decode(type, from: data)
          observer.on(.next(jsonData))
        } catch {
          observer.on(.error(error))
        }
        observer.on(.completed)
      })
      task.resume()
      
      return Disposables.create {
        task.cancel()
      }
    })
  }

}
