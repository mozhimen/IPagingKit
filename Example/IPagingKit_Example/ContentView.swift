//
//  ContentView.swift
//  IPagingKit_Example
//
//  Created by Taiyou on 2025/7/21.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View{
        List {
            ForEach(viewModel.albums) { album in
                Text(album.collectionName)
            }
            Color.clear.onAppear(perform: {
                viewModel.pager.add()
            })
            switch viewModel.loadState {
            case.Start:
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
            case.Empty:
                EmptyView()
                //                case .error(let message):
                //                    Text(message)
                //                        .foregroundColor(.pink)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ContentView()
}
