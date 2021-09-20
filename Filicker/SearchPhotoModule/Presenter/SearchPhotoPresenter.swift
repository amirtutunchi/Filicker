//
//  SearchPhotoPresenter.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import Foundation
import Combine

class SearchPhotoPresenter: ObservableObject {
  let interactor: SearchPhotoInteractor
  @Published var array: [String] = []
  init(interactor: SearchPhotoInteractor) {
    self.interactor = interactor
    addSubscribers()
  }
  @Published var isSearching = false
  @Published var photoArray: [Photo] = []
  @Published var searchText: String = ""
  @Published var temporarySearchText: String = ""
  private var cancellables = Set<AnyCancellable>()
  func addSubscribers() {
    searchPhoto()
    isSearchingSubscriber()
  }
  func isSearchingSubscriber() {
    $isSearching
      .sink { [weak self] value in
        guard let self = self else {
          return
        }
        if value {
          print(self.interactor.getAllCaches())
          self.array = self.interactor.getAllCaches()
        }
      }
      .store(in: &cancellables)
  }
  func searchPhoto(completion: @escaping () -> Void = {}) {
    $searchText
      .sink {[weak self] searchText in
        guard let self = self else { return }
        if searchText.isEmpty {
          self.photoArray = []
          return
        }
        self.interactor.addItemToCache(text: searchText)
        self.interactor.searchPhoto(text: searchText)
          .receive(on: RunLoop.main)
          .sink { [weak self] failure in
            switch failure {
            case .failure(let error):
              print(error)
              self?.photoArray = []
            case .finished:
              completion()
            }
          } receiveValue: { [weak self] result in
            self?.photoArray = result.photos.photos
          }
          .store(in: &self.cancellables)
      }
      .store(in: &cancellables)
  }
}
