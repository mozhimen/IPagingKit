//
//  ContentView.swift
//  IPagingKit_Example
//
//  Created by Taiyou on 2025/7/21.
//

import SwiftUI
import UIKit
import IPagingKit_Pagination

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()

    var body: some View{
        VStack(content: {
            if viewModel.pageState == PageState.LoadFirstEmpty {
                EmptyView()
                    .frame(maxWidth: .infinity,maxHeight:.infinity)
                    .background(Color.red)
            } else if viewModel.pageState == PageState.LoadFirstStart {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
            } else if viewModel.pageState == PageState.LoadFirstFinish {
                List {
                    ForEach(viewModel.albums) { list in
                        Text(list.collectionName)
                            .debugBorder()
//                        switch let state = viewModel.pager.loadState.append
                    }
                    Color.black.onAppear(perform: {
                        viewModel.pager.append(nextKey: viewModel.pager.pagingIndex+1)
                    })
                }
                .listStyle(.plain)
                .background(Color.black)
            }
        })
        .onAppear(perform: {
            viewModel.pager.refresh(key: 0)
        })
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
