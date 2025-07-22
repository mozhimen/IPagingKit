//
//  IPagingKStateSource.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//

protocol IPagingKStateSource<RES,DES>{
    associatedtype RES
    associatedtype DES
    func onLoadStart(currentPageIndex:Int) async
    func onLoading(currentPageIndex:Int,pageSize:Int) async -> PagingKBaseRes<RES>
    func onLoadFinished(currentPageIndex:Int,isResEmpty:Bool) async
}
