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
  private func loadMoreContent(searchKey: String, refresh: Bool = false) {
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
  func loadMoreContentIfNeeded(currentItem item: Photo?) {
    guard let item = item else {
      loadMoreContent(searchKey: searchText)
      return
    }
    let thresholdIndex = photoList.index(photoList.endIndex, offsetBy: -5)
    if photoList.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
      loadMoreContent(searchKey: searchText)
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
        self.loadMoreContent(searchKey: $0, refresh: true)
      }
      .store(in: &cancellables)
  }
  func resetPresenter() {
    self.page = 1
    self.photoList = []
    self.isLoadingPage = false
  }
}
