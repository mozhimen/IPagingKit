//
//  BasePagingKViewModel.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//
import SwiftUI
import Combine
import SUtilKit_SwiftUI

open class BasePagingKViewModel<RES,DES> : BaseViewModel, PPagingKStateSource {
    
    public typealias RES = RES
    public typealias DES = DES
    
    //==========================================================>
    
    @Published var pubLoadState:LoadState? = nil
    open lazy var pager:Pager<Int,DES> = getPager()
    open var pagingConfig :PagingConfig = PagingConfig()
    open var dataSource: (any PPagingKDataSource<RES,DES>)? = nil
    
    //==========================================================>

    open func getPager()-> Pager<Int,DES> {
        return Pager(
            pagingConfig: pagingConfig,
            pagingSource: getPagingSourceFactory()
        )
    }
    
    open func getPagingSourceFactory()-> PagingSource<Int,DES>{
        return InnerPagingKPagingSource(
            pagingConfig: pagingConfig,
            stateSource: self,
            dataSource: dataSource
        )
    }
    
    //==========================================================>
    
    private var _isLoadStartFirst = true
    
    public func onLoadStart(currentPageIndex: Int) async throws {
        if currentPageIndex == pagingConfig.pageIndexFirst {
            if _isLoadStartFirst {
                _isLoadStartFirst = false
                print("onLoadStart:")
                pubLoadState = LoadState.Start(isFirst: true)
            }
        }
    }
    
    
    public func onLoading(currentPageIndex: Int, pageSize: Int) async throws -> PagingKBaseRes<RES> {
        fatalError()
    }
    
    
    public func onLoadFinished(currentPageIndex: Int, isResEmpty: Bool) async throws {
        if currentPageIndex==pagingConfig.pageIndexFirst {
            if isResEmpty {
                print("onLoadFinish: isEmpty \(isResEmpty)")
                pubLoadState = LoadState.Empty
            }
            else{
                pubLoadState = LoadState.Finish
            }
        }
    }
    
    //=============================================================>
    
    class InnerPagingKPagingSource:BasePagingKPagingSource<RES,DES>{
        weak var stateSource: (any PPagingKStateSource<RES,DES>)?
        weak var dataSource: (any PPagingKDataSource<RES,DES>)?
        
        //=========================================================>
        
        init(
            pagingConfig: PagingConfig,
            stateSource:(any PPagingKStateSource<RES,DES>)?,
            dataSource:(any PPagingKDataSource<RES,DES>)?
        ) {
            self.stateSource = stateSource
            self.dataSource = dataSource
            super.init(pagingConfig: pagingConfig)
        }
        
        override init(pagingConfig: PagingConfig) {
            super.init(pagingConfig: pagingConfig)
        }
        
        override func onLoadStart(currentPageIndex: Int) async throws {
            try await stateSource?.onLoadStart(currentPageIndex: currentPageIndex)
        }
        
        override func onLoading(currentPageIndex: Int, pageSize: Int) async throws -> PagingKBaseRes<RES> {
            try await stateSource?.onLoading(currentPageIndex: currentPageIndex, pageSize: pageSize) ?? PagingKBaseRes()
        }
        
        override func onLoadFinished(currentPageIndex: Int, isResEmpty: Bool) async throws {
            try await stateSource?.onLoadFinished(currentPageIndex: currentPageIndex, isResEmpty: isResEmpty)
        }
        
        override func onTransformData(currentPageIndex: Int?, datas: [RES]) async throws -> [DES] {
            try await dataSource?.onTransformData(currentPageIndex: currentPageIndex, datas: datas) ?? []
        }
        
        override func onCombineData(currentPageIndex: Int?, datas: [DES]) async throws {
            try await dataSource?.onCombineData(currentPageIndex: currentPageIndex, datas: datas)
        }
        
        override func onGetHeader() async throws -> [DES]? {
            return try await dataSource?.onGetHeader()
        }
        
        override func onGetFooter() async throws -> [DES]? {
            return try await dataSource?.onGetFooter()
        }
    }
}
