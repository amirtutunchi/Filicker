//
//  ServiceLayer.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
import Combine

class ServiceLayer {
  private var session: URLSession
  private let decoder = JSONDecoder()
  static let sharedInstance = ServiceLayer()
  private init() {
    /// create and config url session configuration
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 20
    config.timeoutIntervalForResource = 20
    /// create and config url session
    self.session = URLSession(configuration: config, delegate: nil, delegateQueue: .init())
  }
  /// this function is used to validate server response and check whether every thing is ok or not
  private func validate(response: HTTPURLResponse?, data: Data?) throws -> Data {
  let errorResponse = data.flatMap { try? decoder.decode(ErrorResponse.self, from: $0) }
    guard let response = response else {
      throw ServiceError.invalidResponse
    }
    switch  response.statusCode {
    case 401:
      throw  ServiceError.badToken(message: errorResponse?.message)
    case 400...600:
      throw ServiceError.badHTTPStatus(status: response.statusCode, message: errorResponse?.message)
    default:
      break
    }
    guard let data = data else {
      throw ServiceError.invalidResponse
    }
    return data
  }
  /// this function is for creating UrlComponents object
  private func createBaseURLComponent(router: Router ) -> URLComponents {
    var components = URLComponents()
    components.scheme = router.scheme
    components.host = router.host
    components.path = router.path
    if router.port != 80 {
      components.port = router.port
    }
    components.queryItems = router.parameters
    return components
  }
  /// this function creates URLRequest object for every request we need
  private func createUrlRequest(router: Router, components: URLComponents) -> URLRequest {
    if let url = components.url {
      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = router.method
      urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
      return urlRequest
    } else {
      fatalError("URL is not valid")
    }
  }
  func request<T: Decodable>(router: Router) -> AnyPublisher<T, Error> {
    let components = createBaseURLComponent(router: router)
    let urlRequest = createUrlRequest(router: router, components: components)
    let dataTask = session.dataTaskPublisher(for: urlRequest)
      .map {
        let json = try! JSONSerialization.jsonObject(with: $0.data, options: .init())
        print(json)
        return $0.data
      }
      
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
    return dataTask
  }
}
