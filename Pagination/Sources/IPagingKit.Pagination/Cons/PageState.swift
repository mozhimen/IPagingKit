//
//  LoadState.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//

public enum PageState: Equatable,Sendable {
    case LoadFirstStart
    case LoadFirstStartFirst
    case LoadFirstFinish
    case LoadFirstEmpty
}
