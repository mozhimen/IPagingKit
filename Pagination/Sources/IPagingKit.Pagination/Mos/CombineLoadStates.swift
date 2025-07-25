//
//  CombineLOadStates.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/25.
//

public struct CombineLoadStates{
    let refresh: LoadState
    let prepend:LoadState
    let append:LoadState
    let source:LoadStates
    let mediator:LoadState?
    
    public init(refresh:LoadState,prepend:LoadState,append:LoadState,source:LoadStates,mediator:LoadState?=nil){
        self.refresh = refresh
        self.prepend = prepend
        self.append = append
        self.source = source
        self.mediator = mediator
    }
}
