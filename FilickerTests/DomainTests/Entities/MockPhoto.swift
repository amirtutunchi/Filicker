//
//  MockPhoto.swift
//  FilickerTests
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
@testable import Filicker
enum MockPhoto {
  static let photo = Photo.init(
    id: "51494530196",
    owner: "",
    secret: "595791b362",
    server: "65535",
    farm: 66,
    title: "Test Image",
    isPublic: 1,
    isFriend: 1,
    isFamily: 1)
  static let photoArray = [photo]
}
