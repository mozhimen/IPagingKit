//
//  PagingKDataRes.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//

public struct PagingKDataRes<RES:Sendable>: CustomStringConvertible, Sendable {
    var currentPageIndex = 0
    var currentPageItems: [RES]? = nil
    var totalPageNum = 0
    var totalItemNum = 0
    var pageSize = 0
    
    //========================================================>
    
    public init(
        currentPageIndex: Int,
        currentPageItems: [RES]?,
        totalPageNum: Int ,
        totalItemNum: Int ,
        pageSize: Int
    ) {
        self.currentPageIndex = currentPageIndex
        self.currentPageItems = currentPageItems
        self.totalPageNum = totalPageNum
        self.totalItemNum = totalItemNum
        self.pageSize = pageSize
    }
    
    //========================================================>
    
    public var description: String{
        return "PagingKDataRes(currentPageIndex=\(currentPageIndex), totalPageNum=\(totalPageNum), totalItemNum=\(totalItemNum), pageSize=\(pageSize), currentPageItems=\(String(describing: currentPageItems)))"
    }
}
