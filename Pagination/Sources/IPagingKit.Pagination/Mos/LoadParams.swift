//
//  LoadParams.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/23.
//

open class LoadParams<KEY>:@unchecked Sendable {
    public let key: KEY?
    public let loadSize: Int
    public let placeholdersEnabled:Bool
    
    //================================================================>
    
    public init(key:KEY?,loadSize:Int,placeholdersEnabled:Bool) {
        self.key=key
        self.loadSize=loadSize
        self.placeholdersEnabled=placeholdersEnabled
    }
    
    //================================================================>
    
    static func create<T>(loadType:LoadType,key:T?,loadSize:Int,placeHoldersEnabled:Bool)->LoadParams<T>{
        return switch loadType {
        case.Refresh:
            Refresh(key: key, loadSize: loadSize, placeholdersEnabled: placeHoldersEnabled)
        case.Prepend:
            Prepend(key: key, loadSize: loadSize, placeholdersEnabled: placeHoldersEnabled)
        case.Append:
            Append(key: key, loadSize: loadSize, placeholdersEnabled: placeHoldersEnabled)
        }
    }
    
    //================================================================>
    
    public class Refresh<K> :LoadParams<K>,@unchecked Sendable{
        public override init(key: K?, loadSize: Int, placeholdersEnabled: Bool) {
            super.init(key: key, loadSize: loadSize, placeholdersEnabled: placeholdersEnabled)
        }
    }

    public class Append<K>:LoadParams<K>,@unchecked Sendable{
        public override init(key: K?, loadSize: Int, placeholdersEnabled: Bool) {
            super.init(key: key, loadSize: loadSize, placeholdersEnabled: placeholdersEnabled)
        }
    }

    public class Prepend<K>:LoadParams<K>,@unchecked Sendable{
        public override init(key: K?, loadSize: Int, placeholdersEnabled: Bool) {
            super.init(key: key, loadSize: loadSize, placeholdersEnabled: placeholdersEnabled)
        }
    }
}


