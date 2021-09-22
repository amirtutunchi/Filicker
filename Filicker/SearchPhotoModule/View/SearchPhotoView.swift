//
//  SearchPhotoView.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import SwiftUI

struct SearchPhotoView: View {
  @ObservedObject var presenter: SearchPhotoPresenter
  init(presenter: SearchPhotoPresenter) {
    self.presenter = presenter
  }
  var body: some View {
    SearchBarView(presenter: presenter)
    ScrollView {
      if presenter.isSearching {
        ForEach(presenter.searchHistoryList, id: \.self) { item in
          Button(
            action: {
              presenter.temporarySearchText = item
              presenter.searchText = item
              presenter.isSearching = false
              UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil)
            }, label: {
              HistoryCellView(item: item)
            })
        }
      } else {
        LazyVGrid(
          columns: [
            GridItem(.flexible(minimum: 100, maximum: 300), spacing: 16),
            GridItem(.flexible(minimum: 100, maximum: 300), spacing: 16)
          ]) {
          ForEach(presenter.photoList) { photo in
            SearchResultView(photo: photo)
              .onAppear {
                presenter.loadMorePhotoIfNeeded(currentItem: photo)
              }
          }
        }
        .padding(.horizontal, 12)
      }
    }
  }
}


struct SearchPhotoView_Previews: PreviewProvider {
  static var previews: some View {
    SearchPhotoModuleBuilder.build()
  }
}
