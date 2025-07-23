//
//  PPagingKDataSource.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/23.
//

public protocol PPagingKDataSource<RES,DES>:AnyObject{
    associatedtype RES
    associatedtype DES
    func onCombineData(currentPageIndex:Int?,datas: [DES]) async throws
    func onTransformData(currentPageIndex:Int?,datas: [RES]) async throws-> [DES]
    func onGetHeader()async throws ->[DES]?
    func onGetFooter()async throws ->[DES]?
}
