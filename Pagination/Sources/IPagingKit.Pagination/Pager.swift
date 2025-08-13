//
//  Pager.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//
import SwiftUI
import Foundation
import Combine

@MainActor
open class Pager<KEY,VALUE>:ObservableObject {
    
    let pagingConfig: PagingConfig
    let pagingSource: PagingSource<KEY,VALUE>
    let initialKey: KEY?
    let InCompleteLoadState: LoadState
    let InitialLoadStates: LoadStates
    
    //=====================================================>
    
    init(
        initialKey: KEY?,
        pagingConfig: PagingConfig,
        pagingSource: PagingSource<KEY,VALUE>
    ) {
        self.initialKey = initialKey
        self.pagingConfig = pagingConfig
        self.pagingSource = pagingSource
        self.InCompleteLoadState = LoadState.NotLoading(endOfPaginationReached: false)
        self.InitialLoadStates = LoadStates(refresh: LoadState.Loading(), prepend: InCompleteLoadState, append: InCompleteLoadState)
        self.loadState = CombineLoadStates(refresh: InitialLoadStates.refresh, prepend: InitialLoadStates.prepend, append: InitialLoadStates.append, source: InitialLoadStates)
    }
    
    //=====================================================>
    
    @Published public private(set) var itemSnapshotList: [VALUE] = []
    @Published public private(set) var pagingIndex :Int = 0
    @Published public private(set) var loadState: CombineLoadStates
    
    //=====================================================>
    
    public func refresh(
        key:KEY?
    ){
        Task {
            let params = loadParams(loadType: .Refresh, key: key)
            let loadResult: LoadResult<KEY,VALUE> = await pagingSource.load(params: params)
            presentPagingEvent(loadParams: params, loadResult: loadResult)
        }
    }
    
    public func append(
        nextKey:KEY
    ) {
        if itemSnapshotList.count % pagingConfig.pageSize != 0 {
            return
        }
        Task {
            let params = loadParams(loadType: .Append, key: nextKey)
            let loadResult: LoadResult<KEY,VALUE> = await pagingSource.load(params: params)
            presentPagingEvent(loadParams: params, loadResult: loadResult)
        }
    }
    
    //=====================================================>
    
    private func presentPagingEvent(loadParams:LoadParams<KEY>,loadResult:LoadResult<KEY,VALUE>){
        switch loadParams {
        case is LoadParams<KEY>.Refresh<KEY>:
            if let page = loadResult as? LoadResult<KEY,VALUE>.Page {
                itemSnapshotList = page.data
                pagingIndex = pagingConfig.pageIndexFirst
                print("Refresh page: \(pagingIndex) data: \(itemSnapshotList.count) last: \(itemSnapshotList.last)")
            }
        case is LoadParams<KEY>.Append<KEY>:
            if let page = loadResult as? LoadResult<KEY,VALUE>.Page {
                itemSnapshotList.append(contentsOf: page.data)
                pagingIndex += 1
                print("Append page: \(pagingIndex) data: \(itemSnapshotList.count) last: \(itemSnapshotList.last)")
            }
        default:
            print("other")
        }
    }
    
    private func loadParams(loadType:LoadType,key:KEY?) -> LoadParams<KEY> {
        let pageSize = if loadType == .Refresh { pagingConfig.initialLoadSize } else { pagingConfig.pageSize }
        return LoadParams<KEY>.create(loadType: loadType, key: key, loadSize: pageSize , placeHoldersEnabled: pagingConfig.enablePlaceholders)
    }
}
