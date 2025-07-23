//
//  LoadResult.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/23.
//

open class LoadResult<KEY,VALUE>{
    public class Wrong<K,V> : LoadResult<K,V>{
        public let error: Error
        
        init(error: Error) {
            self.error = error
        }
    }

    public class Invalid<K,V>: LoadResult<K,V>{
        
    }

    public class Page<K,V>:LoadResult<K,V>{
        public let data:[V]
        public let preKey:K?
        public let nextKey:K?
        public let itemsBefore:Int
        public let itemsAfter:Int
        
        //======================================================================>
        
        init(data: [V], preKey: K?, nextKey: K?,itemsBefore:Int=Int.max,itemsAfter:Int=Int.max) {
            self.data = data
            self.preKey = preKey
            self.nextKey = nextKey
            self.itemsBefore=itemsBefore
            self.itemsAfter=itemsAfter
        }
        
        //======================================================================>
        
        static func empty<KK,VV>() -> Page<KK,VV>{
            return Page<KK,VV>(data: [], preKey: nil, nextKey: nil,itemsBefore: 0,itemsAfter: 0)
        }
    }
}


