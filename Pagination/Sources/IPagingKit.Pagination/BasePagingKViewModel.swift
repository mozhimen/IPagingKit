//
//  BasePagingKViewModel.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//
import SwiftUI

open class BasePagingKViewModel<RES,DES> : IPagingKStateSource,ObservableObject{
    
    @Published let pubLoadState:Int? = nil
    
    //==========================================================>
    
    open func getPager()-> Pager<DES> {
        return Pager(
            config =
        )
    }
    
    open func getPagingConfig() -> PagingConfig {
        return
    }
    
    //==========================================================>
    func onLoadStart(currentPageIndex: Int) async {
        
    }
    
    func onLoading(currentPageIndex: Int, pageSize: Int) async -> PagingKBaseRes<RES> {
        fatalError()
    }
    
    func onLoadFinished(currentPageIndex: Int, isResEmpty: Bool) async {
        
    }
}
