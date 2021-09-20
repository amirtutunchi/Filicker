//
//  PhotoServices.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
import Combine

class PhotoServices: PhotoRepository {
  let api: ServiceLayer
  init(api: ServiceLayer) {
    self.api = api
  }
  func searchPhoto(text: String, page: Int) -> AnyPublisher<ResponseBody, Error> {
    return api.request(router: Router.searchImages(text: text, page: page))
  }
}
