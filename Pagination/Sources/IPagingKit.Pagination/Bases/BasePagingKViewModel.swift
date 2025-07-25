//
//  BasePagingKViewModel.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//
import SwiftUI
import Combine
import SUtilKit_SwiftUI

@MainActor
open class BasePagingKViewModel<RES:Sendable,DES:Sendable> : BaseViewModel, PPagingKStateSource, PPagingKDataSource {

    


    //==========================================================>
    
    @Published public var pageState: PageState? = nil
    open lazy var pager: Pager<Int,DES> = getPager()
    open var pagingConfig :PagingConfig = PagingConfig()

    
    //==========================================================>
    
    public init(pagingConfig: PagingConfig) {
        self.pagingConfig = pagingConfig
        super.init()
    }
    
    //==========================================================>

    open func getPager()-> Pager<Int,DES> {
        return Pager(
            initialKey: pagingConfig.pageIndexFirst,
            pagingConfig: pagingConfig,
            pagingSource: getPagingSourceFactory()
        )
    }
    
    open func getPagingSourceFactory()-> PagingSource<Int,DES>{
        return InnerPagingKPagingSource(
            pagingConfig: pagingConfig,
            stateSource: self,
            dataSource: self
        )
    }
    
    //==========================================================>
    
    private var _isLoadStartFirst = true
    
    open func onLoadStart(currentPageIndex: Int) async throws {
        if currentPageIndex == pagingConfig.pageIndexFirst {
            if _isLoadStartFirst {
                _isLoadStartFirst = false
                print("onLoadStart: LoadFirstStartFirst currentPageIndex \(currentPageIndex)")
                pageState = PageState.LoadFirstStartFirst
            }
            print("onLoadStart: LoadFirstStart currentPageIndex \(currentPageIndex)")
            pageState = PageState.LoadFirstStart
        }
    }
    
    
    open func onLoading(currentPageIndex: Int, pageSize: Int) async throws -> PagingKBaseRes<RES> {
        fatalError()
    }
    
    
    open func onLoadFinished(currentPageIndex: Int, isResEmpty: Bool) async throws {
        if currentPageIndex==pagingConfig.pageIndexFirst {
            if isResEmpty {
                print("onLoadFinish: LoadFirstEmpty currentPageIndex \(currentPageIndex) isEmpty \(isResEmpty)")
                pageState = PageState.LoadFirstEmpty
            }
            else{
                print("onLoadFinish: LoadFirstFinish currentPageIndex \(currentPageIndex) isEmpty \(isResEmpty)")
                pageState = PageState.LoadFirstFinish
            }
        }
    }
    
    open func onCombineData(currentPageIndex: Int?, datas: [DES]) async throws {
    }
    
    open func onTransformData(currentPageIndex: Int?, datas: [RES]) async throws -> [DES] {
        fatalError()
    }
    
    open func onGetHeader() async throws -> [DES]? {
        return nil
    }
    
    open func onGetFooter() async throws -> [DES]? {
        return nil
    }
    
    //=============================================================>
    
    class InnerPagingKPagingSource:BasePagingKPagingSource<RES,DES>,@unchecked Sendable{
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
