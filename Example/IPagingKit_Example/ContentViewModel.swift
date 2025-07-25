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
    
    private let _api = Apis(retrofit: Retroft.Builder().setStrScheme("https").setStrHost("itunes.apple.com").build())
    
    //=================================================================>
    
    init() {
        let pagingConfig = PagingConfig(pageIndexFirst: 0)
        super.init(pagingConfig: pagingConfig)
        $searchText
            .filter({ str in
                return !str.isEmpty
            })
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.pager.refresh(key: pagingConfig.pageIndexFirst)
            }.store(in: &viewModelScope)
    }
    
    //=================================================================>

    override func onTransformData(currentPageIndex: Int?, datas: [Album]) async throws -> [Album] {
        return datas
    }
    
    override func onLoading(currentPageIndex: Int, pageSize: Int) async throws -> PagingKBaseRes<Album> {
        let res = try await _api.search(Apis.SearchRequest(term: searchText,limit: pagingConfig.pageSize, offset: currentPageIndex*pagingConfig.pageSize))
        var totalPageCount = currentPageIndex+2
        var totalItemCount = totalPageCount*pageSize
        if let count = res?.resultCount,count < pagingConfig.pageSize {
            totalItemCount = currentPageIndex*pageSize+count
            totalPageCount = currentPageIndex+1
        }
        let pagingKBaseRes = PagingKBaseRes(1, nil, PagingKDataRes(currentPageIndex: currentPageIndex, currentPageItems: res?.results, totalPageNum: totalPageCount, totalItemNum: totalItemCount, pageSize: pagingConfig.pageSize))
        return pagingKBaseRes
    }
}
