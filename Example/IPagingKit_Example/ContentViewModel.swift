//
//  ContentViewModel.swift
//  IPagingKit_Example
//
//  Created by Taiyou on 2025/7/21.
//

import SwiftUI
import Foundation
import Combine
import SUtilKit_SwiftUI
import IPagingKit_Pagination
import INetKit_Retrofit


//enum LoadState: Comparable {
//    case loadStart
//    case loadEmpty
//    case loading
//    case loadFinished(PageState)
//    case loadError(String)
//        
//    case good
//    case isLoading
//    case loadedAll∂
//    case error(String)
//}

class ContentViewModel:BasePagingKViewModel<Album,Album> {
    
    
    @Published var searchText: String = "rammstein"
    @Published var albums: [Album] = [Album]()
    
    let limit: Int = 20
    var page: Int = 0
    
    private let _api = Apis(retrofit: Retroft.Builder().setStrScheme("https").setStrHost("itunes.apple.com").build())
    
    //=================================================================>
    
    init() {
        $searchText
            .filter({ str in
                return !str.isEmpty && loadState != LoadState.Start
            })
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.loadState = .loadStart
                self?.albums = []
                self?.fetchAlbums(term)
            }.store(in: &subscriptions)
        super.init(pagingConfig: PagingConfig(pageIndexFirst: 0))
    }
    
    //=================================================================>

    override func onLoading(currentPageIndex: Int, pageSize: Int) async throws -> PagingKBaseRes<Album> {
        let res = try await _api.search(Apis.SearchRequest(searchText: searchText,limit: pagingConfig.pageSize, offset: currentPageIndex*pagingConfig.pageSize))
        var totalPageCount = currentPageIndex+2
        var totalItemCount = totalPageCount*pageSize
        if let count = res?.resultCount,count < pagingConfig.pageSize {
            totalItemCount = currentPageIndex*pageSize+count
            totalPageCount = currentPageIndex+1
        }
        return PagingKBaseRes(0, nil, PagingKDataRes(currentPageIndex: currentPageIndex, currentPageItems: res?.results, totalPageNum: totalPageCount, totalItemNum: totalItemCount, pageSize: pagingConfig.pageSize))
    }
    
    func fetchAlbums(_ searchText: String) {
        
        
        guard loadState == LoadState.loadStart else {
            return
        }
        
        let offset = page * limit
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&entity=album&limit=\(limit)&offset=\(offset)") else {
            return
        }
        
        
        print("start fetching data for \(searchText)")
        loadState = .isLoading
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("urlsession error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.loadState = .error("Could not load: \(error.localizedDescription)")
                }
            } else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(AlbumResult.self, from: data)
                    DispatchQueue.main.async {
                        for album in result.results {
                            self?.albums.append(album)
                        }
                        self?.page += 1
                        self?.loadState = (result.results.count == self?.limit) ? .good : .loadedAll
                        print("fetched \(result.resultCount)")
                    }
                   
                } catch {
                    print("decoding error \(error)")
                    DispatchQueue.main.async {
                        self?.loadState = .loadError("Could not get data: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
}
