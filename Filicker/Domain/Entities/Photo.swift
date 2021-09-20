//
//  Photo.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
struct Photo: Decodable {
  let id: String
  let owner: String
  let secret: String
  let server: String
  let farm: Int
  let title: String
  let isPublic: Int
  let isFriend: Int
  let isFamily: Int
  enum CodingKeys: String, CodingKey {
    case id, owner, secret, server, farm, title
    case isPublic = "ispublic"
    case isFriend = "isfriend"
    case isFamily = "isfamily"
  }
  var urlString: String {
    return  "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
  }
}
extension Photo: Identifiable {}
