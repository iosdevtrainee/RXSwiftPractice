import Foundation
import RxSwift
enum IPifyAPIError:Error {
  case invalidURL(String)
  case networkError(Error)
  case decodingError(Error)
}

struct IPAddress: Codable {
  public let ip: String
}

final class IPifyAPIClient {
  private let ipURLString = "https://api.ipify.org?format=json"
  public func getDeviceIPAdress(apiKey:String) -> Observable<IPAddress> {
    guard let url = URL(string: ipURLString) else {
      return Observable.error(IPifyAPIError.invalidURL(ipURLString))
    }
    return URLSession.shared.rx.response(url: url, type:IPAddress.self)
  }
  
  public func fetchLocationData(apiKey:String,
                                ipAddress:IPAddress) -> Observable<IPAddress> {
    let urlString = "https://geo.ipify.org/api/v1?apiKey=\(apiKey)&ipAddress=\(ipAddress)"
    guard let url = URL(string: urlString) else {
      return Observable.error(IPifyAPIError.invalidURL(ipURLString))
    }
    return URLSession.shared.rx.response(url: url, type: IPAddress.self)
}

}
