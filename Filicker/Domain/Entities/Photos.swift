//
//  Photos.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
struct Photos: Decodable {
  let page: Int
  let pages: Int
  let perPage: Int
  let total: Int
  let photos: [Photo]
  enum CodingKeys: String, CodingKey {
    case page, pages, total
    case photos = "photo"
    case perPage = "perpage"
  }
}
