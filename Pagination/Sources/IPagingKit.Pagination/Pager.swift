//
//  Pager.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//
import SwiftUI
import Foundation
import Combine

open class Pager<KEY,VALUE>{
    let pagingConfig: PagingConfig
    let pagingSource: PagingSource<KEY,VALUE>
    let initialKey: KEY?
    
    //=====================================================>
    
    init(
        initialKey: KEY?,
        pagingConfig: PagingConfig,
        pagingSource: PagingSource<KEY,VALUE>
    ) {
        self.initialKey = initialKey
        self.pagingConfig = pagingConfig
        self.pagingSource = pagingSource
        initial(key: initialKey, pagingConfig: pagingConfig)
    }
    
    //=====================================================>
    
    @Published public var itemSnapshotList: [VALUE] = []
    @Published public var pagingIndex :Int = 0
    @Published public var loadState: 
    
    //=====================================================>
    
    func initial(
        key:KEY?,
        pagingConfig:PagingConfig
    ){
        let params = loadParams(loadType: .Refresh, key: key)
        Task(operation: {
            let loadResult: LoadResult<KEY,VALUE> = try await pagingSource.load(params: params)
            itemSnapshotList = loadResult
        })
    }
    
    public func add() {
        Task(operation: {
            let loadResult: LoadResult<KEY,VALUE> = pagingSource.load(params: LoadParams.create(loadType: LoadType.Append, key: KEY, loadSize: pagingConfig.pageSize, placeHoldersEnabled: pagingConfig.enablePlaceholders))
        })
    }
    
    //=====================================================>
    
    private func loadParams(loadType:LoadType,key:KEY?) -> LoadParams<KEY> {
        let pageSize = if loadType == .Refresh { pagingConfig.initialLoadSize } else { pagingConfig.pageSize }
        return LoadParams<KEY>.create(loadType: loadType, key: key, loadSize: pageSize , placeHoldersEnabled: pagingConfig.enablePlaceholders)
    }
}
