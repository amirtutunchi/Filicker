//
//  SearchResultView.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import SwiftUI
import Kingfisher

struct SearchResultView: View {
  var photo: Photo
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      KFImage.init(URL.init(string: photo.urlString))
        .resizable()
        .scaledToFit()
      Text(photo.title)
        .bold()
      Spacer()
    }
  }
}
