//
//  SearchPhotoPresenterTests.swift
//  FilickerTests
//
//  Created by Amir Tutunchi on 9/22/21.
//

import XCTest
@testable import Filicker

class SearchPhotoPresenterTests: XCTestCase {
  var sut: SearchPhotoPresenter?
  override func setUpWithError() throws {
    try super.setUpWithError()
    let mockPhotoService = MockPhotoService()
    let mockCacheService = MockCacheService()
    let interactor = SearchPhotoInteractor.init(
      searchPhotoRepository: mockPhotoService,
      cacheRepository: mockCacheService)
    sut = SearchPhotoPresenter.init(interactor: interactor)
  }
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
  }
  func test_resetPresenter_setCorrectResult() {
    sut?.resetPresenter()
    XCTAssert(sut?.page == 1)
    XCTAssert(sut?.photoList.isEmpty ?? false)
    XCTAssert(sut?.isLoadingPage == false)
  }
}
