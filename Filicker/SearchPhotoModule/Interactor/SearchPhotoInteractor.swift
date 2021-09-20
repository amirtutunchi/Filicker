//
//  SearchPhotoInteractor.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
import Combine

class SearchPhotoInteractor {
  let searchPhotoRepository: PhotoRepository
  let cacheRepository: CacheRepository
  init(searchPhotoRepository: PhotoRepository, cacheRepository: CacheRepository) {
    self.searchPhotoRepository = searchPhotoRepository
    self.cacheRepository = cacheRepository
  }
  func searchPhoto(text: String) -> AnyPublisher<ResponseBody, Error> {
    return searchPhotoRepository.searchPhoto(text: text)
  }
  func getAllCaches() -> [String] {
    return cacheRepository.getAllItems()
  }
  func addItemToCache(text: String) {
    cacheRepository.addItem(text: text)
  }
}
