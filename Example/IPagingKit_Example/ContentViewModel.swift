//
//  ContentViewModel.swift
//  IPagingKit_Example
//
//  Created by Taiyou on 2025/7/21.
//

import SwiftUI

class ContentViewModel:ObservableObject{
    @State var data = Array(1...20)
    @State var isLoadingMore = false
    @State var itemColors: [Int: Color] = [:]
    let loadMoreDelay: Double = 1.5
    
    func loadMoreIfNeeded(currentItem: Int) {
        guard !isLoadingMore, currentItem == data.last else { return }
        loadMore()
    }
    
    func loadMore() {
        isLoadingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadMoreDelay) {
            let nextItems = self.data.count + 1...self.data.count + 20
            self.data.append(contentsOf: nextItems)
            self.setupColors()
            self.isLoadingMore = false
        }
    }
    
    func setupColors() {
        for index in data {
            if itemColors[index] == nil {
                itemColors[index] = randomColor()
            }
        }
    }
    
    func getColor(for index: Int) -> Color {
        return itemColors[index] ?? Color.clear
    }
    
    func randomColor() -> Color {
        Color(hue: .random(in: 0...1), saturation: .random(in: 0.5...1), brightness: .random(in: 0.6...1))
    }
}
