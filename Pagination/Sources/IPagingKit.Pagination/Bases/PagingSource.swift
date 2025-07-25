//
//  PagingSource.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/23.
//

open class PagingSource<KEY,VALUE>:@unchecked Sendable{
    func load(params:LoadParams<KEY>)async -> LoadResult<KEY,VALUE> {
        fatalError()
    }
}
