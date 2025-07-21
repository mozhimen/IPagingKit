//
//  ContentView.swift
//  IPagingKit_Example
//
//  Created by Taiyou on 2025/7/21.
//

import SwiftUI
import UIKit

struct ContentView: View {

    private var vm = ContentViewModel()
    private let gridSpacing: CGFloat = 5
    private let gridItemPadding: CGFloat = 5
    
    
    private var gridColumn: [GridItem] {
        [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 3 - gridItemPadding * 2))]
    }
        
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                spacing: gridSpacing,
                content: {
                    ForEach(vm.data, id: \.self) { item in
                        Text(String(item))
                            .frame(width: UIScreen.main.bounds.width / 3 - gridSpacing, height: 150)
                            .background(vm.getColor(for: item))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .font(.title)
                            .onAppear {
                                vm.loadMoreIfNeeded(currentItem: item)
                            }
                    }
                })
            .padding(.horizontal, gridItemPadding)
            if vm.isLoadingMore {
                ProgressView("Loading more...")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.vertical)
            }
        }.onAppear(perform: vm.setupColors)
    }
    

}

#Preview {
    ContentView()
}
