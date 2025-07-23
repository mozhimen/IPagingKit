//
//  IPagingKStateSource.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//

public protocol PPagingKStateSource<RES,DES>:AnyObject{
    associatedtype RES
    associatedtype DES
    func onLoadStart(currentPageIndex:Int) async throws
    func onLoading(currentPageIndex:Int,pageSize:Int) async throws -> PagingKBaseRes<RES>
    func onLoadFinished(currentPageIndex:Int,isResEmpty:Bool) async throws
}
