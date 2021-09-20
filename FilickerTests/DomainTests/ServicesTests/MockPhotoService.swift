//
//  MockPhotoService.swift
//  FilickerTests
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
@testable import Filicker
import Combine

class MockPhotoService: PhotoRepository {
  func searchPhoto(text: String) -> AnyPublisher<ResponseBody, Error> {
    return Future<ResponseBody, Error> { promise in
      let photos = Photos.init(
        page: 1,
        pages: 1,
        perPage: 100,
        total: 1,
        photos: MockPhoto.photoArray)
      let response = ResponseBody.init(photos: photos, stat: "ok")
      promise( .success(response))
    }
    .eraseToAnyPublisher()
  }
}
