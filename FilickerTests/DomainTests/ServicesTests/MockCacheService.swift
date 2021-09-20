//
//  MockCacheService.swift
//  FilickerTests
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
@testable import Filicker

class MockCacheService: CacheRepository {
  var userDefault = UserDefaults.init(suiteName: "test") ?? .standard
  private let key = "TestHistorySearchResult"
  func addItem(text: String) {
    if checkIfNotExist(text: text) {
      var array = getAllItems()
      array.append(text)
      userDefault.setValue(array, forKey: key)
    }
  }
  func getAllItems() -> [String] {
    return userDefault.stringArray(forKey: key) ?? []
  }
  private func checkIfNotExist(text: String) -> Bool {
    return !self.getAllItems().contains(text)
  }
}
