//
//  LoadStates.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/25.
//

public struct LoadStates{
    public let refresh:LoadState
    public let prepend:LoadState
    public let append:LoadState
    
    public init(refresh: LoadState, prepend: LoadState, append: LoadState) {
        self.refresh = refresh
        self.prepend = prepend
        self.append = append
    }
}
