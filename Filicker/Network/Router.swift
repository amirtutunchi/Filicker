//
//  Router.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation

enum Router {
  case searchImages(text: String, page: Int)
  var scheme: String {
    return "https"
  }
  var host: String {
    return "api.flickr.com"
  }
  var port: Int? {
    return nil
  }
  var path: String {
    switch self {
    case .searchImages:
      return "/services/rest/"
    }
  }
  var parameters: [URLQueryItem] {
    switch self {
    case .searchImages(let text, let page):
      return [
        URLQueryItem.init(name: "method", value: "flickr.photos.search"),
        URLQueryItem.init(name: "api_key", value: "11c40ef31e4961acf4f98c8ff4e945d7"),
        URLQueryItem.init(name: "format", value: "json"),
        URLQueryItem.init(name: "nojsoncallback", value: "1"),
        URLQueryItem.init(name: "text", value: text),
        URLQueryItem.init(name: "page", value: String(page))
      ]
    }
  }
  var bodyParams: Data? {
    switch self {
    case .searchImages:
      return nil
    }
  }
  var method: String {
    switch self {
    case .searchImages:
      return "GET"
    }
  }
}
