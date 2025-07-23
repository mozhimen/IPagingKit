//
//  Pager.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//
import SwiftUI

open class Pager<KEY,VALUE>{
    let pagingConfig: PagingConfig
    let pagingSource: PagingSource<KEY,VALUE>
    
    //=====================================================>
    
    init(
        pagingConfig: PagingConfig,
        pagingSource: PagingSource<KEY,VALUE>
    ) {
        self.pagingConfig = pagingConfig
        self.pagingSource = pagingSource
    }
    
    //=====================================================>
    
    @Published var itemSnapshotList: [VALUE] = []
}
