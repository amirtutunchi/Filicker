//
//  PhotoRepository.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
import Combine

protocol PhotoRepository {
  func searchPhoto(text: String) -> AnyPublisher<ResponseBody, Error>
}
