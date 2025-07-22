//
//  PagingConfig.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//

struct PagingConfig{
    let pageIndexFirst:Int = 1
    let pageSize: Int = 10
    let prefetchDistance:Int =pageSize/2
    let initialLoadSize= pageSize/2
    let enablePlaceholders:Bool = true
}
