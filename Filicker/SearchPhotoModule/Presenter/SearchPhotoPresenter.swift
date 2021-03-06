//
//  SearchPhotoPresenter.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
import Combine

class SearchPhotoPresenter: ObservableObject {
  private let interactor: SearchPhotoInteractor
  @Published var searchHistoryList: [String] = []
  init(interactor: SearchPhotoInteractor) {
    self.interactor = interactor
    addSubscribers()
  }
  private(set) var page = 1
  @Published var isSearching = false
  @Published var photoList: [Photo] = []
  @Published var searchText: String = ""
  @Published var temporarySearchText: String = ""
  @Published var isLoadingPage = false
  private var canLoadMorePages = true
  private var cancellables = Set<AnyCancellable>()
  private func addSubscribers() {
    searchPhotoSubscriber()
    isSearchingSubscriber()
  }
  /// this function get search history and set it to searchHistoryList when user start searching
  private func isSearchingSubscriber() {
    $isSearching
      .sink { [weak self] value in
        guard let self = self else {
          return
        }
        if value {
          self.searchHistoryList = self.interactor.getAllCaches()
        }
      }
      .store(in: &cancellables)
  }
  /// This function load photo with search key if we can load more photo and isLoadingPage is false
  /// - Parameters:
  ///   - searchKey: the search text user typing
  ///   - refresh: this variable indicates that does the search result need to be append to previous result or not
  private func loadPhoto(searchKey: String, refresh: Bool = false) {
    guard !isLoadingPage && canLoadMorePages else {
      return
    }
    isLoadingPage = true
    interactor.searchPhoto(text: searchKey, page: self.page)
      .receive(on: RunLoop.main)
      .handleEvents(receiveOutput: { response in
        self.canLoadMorePages = self.page < response.photos.pages
        self.isLoadingPage = false
        self.page += 1
      })
      .map { response in
        if refresh {
          return response.photos.photos
        } else {
          return self.photoList + response.photos.photos
        }
      }
      .sink(receiveCompletion: { [weak self] failure in
        if case .failure(let error) = failure {
          print(error)
          self?.isLoadingPage = false
          self?.photoList = []
        }
      }, receiveValue: { photos in
        self.photoList = photos
      })
      .store(in: &cancellables)
  }
  func loadMorePhotoIfNeeded(currentItem item: Photo?) {
    guard let item = item else {
      loadPhoto(searchKey: searchText)
      return
    }
    let thresholdIndex = photoList.index(photoList.endIndex, offsetBy: -5)
    if photoList.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
      loadPhoto(searchKey: searchText)
    }
  }
  private func searchPhotoSubscriber() {
    $searchText
      .sink {[weak self] in
        guard let self = self else { return }
        self.resetPresenter()
        if $0.isEmpty {
          return
        }
        self.interactor.addItemToCache(text: $0)
        self.loadPhoto(searchKey: $0, refresh: true)
      }
      .store(in: &cancellables)
  }
  func resetPresenter() {
    self.page = 1
    self.photoList = []
    self.isLoadingPage = false
  }
}
