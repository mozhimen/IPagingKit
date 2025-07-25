//
//  LoadState.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/24.
//

open class LoadState:@unchecked Sendable{
    let endOfPaginationReached: Bool
    
    init(endOfPaginationReached:Bool) {
        self.endOfPaginationReached = endOfPaginationReached
    }
    
    //================================================>
    
    
    final class NotLoading:LoadState,@unchecked Sendable{
        override init(endOfPaginationReached:Bool) {
            super.init(endOfPaginationReached: endOfPaginationReached)
        }
        
        static let Complete = NotLoading(endOfPaginationReached: true)
        static let InComplete = NotLoading(endOfPaginationReached: false)
    }
    
    final class Loading:LoadState,@unchecked Sendable{
        init() {
            super.init(endOfPaginationReached: false)
        }
    }
    
    final class Error:LoadState,@unchecked Sendable{
        let error: Error
        init(error: Error) {
            self.error = error
            super.init(endOfPaginationReached: false)
        }
    }
}
