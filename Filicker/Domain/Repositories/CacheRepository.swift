//
//  CacheRepository.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation

protocol CacheRepository {
  func addItem(text: String)
  func getAllItems() -> [String]
}
