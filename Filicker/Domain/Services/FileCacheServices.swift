//
//  FileCacheServices.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation

class FileCacheServices: CacheRepository {
  var userDefault: UserDefaults = .standard
  private let key = "historySearchResult"
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
