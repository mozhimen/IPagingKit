//
//  PagingKBaseRes.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//

public struct PagingKBaseRes<RES>:CustomStringConvertible {
    var code: Int = 0
    var msg: String? = nil
    var data: PagingKDataRes<RES>? = nil
    
    //==============================================>
    
    public init() { }
    
    public init(_ code: Int,_  msg: String?) {
        self.code = code
        self.msg = msg
    }
    
    public init(_ code: Int,_  msg: String?, _ data: PagingKDataRes<RES>?) {
        self.code = code
        self.msg = msg
        self.data = data
    }
    
    //==============================================>
    
    static func  empty<T>() -> PagingKBaseRes<T> {
        return PagingKBaseRes<T>(0, nil)
    }
    
    //==============================================>
    
    func isSuccessful()->Bool {
        return code==1
    }
    
    //==============================================>
    
    public var description: String {
        return "PagingKBaseRes(code=\(code), msg=\(String(describing: msg)), data=\(String(describing: data)))"
    }
}
