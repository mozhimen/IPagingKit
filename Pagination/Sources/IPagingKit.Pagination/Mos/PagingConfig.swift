//
//  PagingConfig.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//

public struct PagingConfig{
    public let pageIndexFirst:Int
    public let pageSize: Int
    public let prefetchDistance: Int
    public let initialLoadSize:Int
    public let enablePlaceholders:Bool
    
    public init(pageIndexFirst:Int=1,pageSize:Int=10,prefetchDistance:Int=5,initialLoadSize:Int=5,enablePlaceholders:Bool=true) {
        self.pageIndexFirst=pageIndexFirst
        self.pageSize=pageSize
        self.prefetchDistance=prefetchDistance
        self.initialLoadSize=initialLoadSize
        self.enablePlaceholders=enablePlaceholders
    }
}
