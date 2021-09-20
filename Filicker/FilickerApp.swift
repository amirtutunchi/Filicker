//
//  FilickerApp.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import SwiftUI

@main
struct FilickerApp: App {
  var body: some Scene {
    WindowGroup {
      SearchPhotoModuleBuilder.build()
    }
  }
}
