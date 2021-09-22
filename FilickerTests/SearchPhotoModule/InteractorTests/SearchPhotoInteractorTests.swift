//
//  SearchPhotoInteractorTests.swift
//  FilickerTests
//
//  Created by Amir Tutunchi on 9/20/21.
//

import XCTest
import Combine
@testable import Filicker

class SearchPhotoInteractorTests: XCTestCase {
  var sut: SearchPhotoInteractor?
  private let spyText = "Spy"
  private var cancellables = Set<AnyCancellable>()
  override func setUpWithError() throws {
    try super.setUpWithError()
    let mockPhotoService = MockPhotoService()
    let mockCacheService = MockCacheService()
    sut = SearchPhotoInteractor.init(
      searchPhotoRepository: mockPhotoService,
      cacheRepository: mockCacheService)
  }
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
  }
  func test_searchPhoto_returnResult() {
    let publisher = sut?.searchPhoto(text: "test", page: 1)
    let expectation = XCTestExpectation(description: "Publish finish without any error")
    publisher?.sink(receiveCompletion: { failure in
      if case .finished = failure {
        expectation.fulfill()
      } else {
        XCTAssert(false, "subscription finished with error")
      }
    }, receiveValue: { responseBody in
      XCTAssert(responseBody.photos.photos.count == 1)
      XCTAssert(responseBody.photos.photos[0].urlString == MockPhoto.photoArray[0].urlString)
    })
    .store(in: &cancellables)
  }
  func test_addAndGetItemToCache_worksCorrectly() {
    sut?.addItemToCache(text: spyText)
    let cache = sut?.getAllCaches()
    XCTAssert(cache?.contains(spyText) ?? false)
  }
}
