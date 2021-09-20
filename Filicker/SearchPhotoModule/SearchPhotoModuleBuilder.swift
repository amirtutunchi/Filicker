//
//  SearchPhotoModuleBuilder.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
import SwiftUI

enum SearchPhotoModuleBuilder {
  static func build() -> some View {
    let api = ServiceLayer.sharedInstance
    let cache = FileCacheServices.init()
    let service = PhotoServices.init(api: api)
    let interactor = SearchPhotoInteractor.init(searchPhotoRepository: service, cacheRepository: cache)
    let presenter = SearchPhotoPresenter.init(interactor: interactor)
    let view = SearchPhotoView.init(presenter: presenter)
    return view
  }
}
