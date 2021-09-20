//
//  HistoryCellView.swift
//  Filicker
//
//  Created by Amir Tutunchi on 9/20/21.
//

import SwiftUI

struct HistoryCellView: View {
  var item: String
  var body: some View {
    HStack {
      Text("\(item)")
      Spacer()
    }.padding()
    Divider()
      .background(Color(.systemGray4))
      .padding(.leading)
  }
}

struct HistoryCellView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryCellView(item: "test")
  }
}
