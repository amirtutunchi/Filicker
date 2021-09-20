//
//  ResponseBody.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
struct ResponseBody: Decodable {
  let photos: Photos
  let stat: String
}
