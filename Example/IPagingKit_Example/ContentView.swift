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
            
            switch viewModel.loadState {
            case .loadStart:
                    Color.clear
                        .onAppear {
                            viewModel.loadMore()
                        }
            case .loading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                case .e:
                    EmptyView()
                case .error(let message):
                    Text(message)
                        .foregroundColor(.pink)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ContentView()
}
