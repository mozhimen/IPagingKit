//
//  BasePagingKPagingSource.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/23.
//

open class BasePagingKPagingSource<RES,DES>: PagingSource<Int,DES>,
                                             PPagingKDataSource,
                                             PPagingKStateSource
{
    public typealias RES = RES
    public typealias DES = DES
    
    //============================================================>
    
    open var pagingConfig: PagingConfig
    
    //============================================================>
    
    init(pagingConfig: PagingConfig) {
        self.pagingConfig = pagingConfig
    }
    
    //============================================================>
    
    public func onCombineData(currentPageIndex: Int?, datas: [DES]) async throws {
    }
    
    public func onTransformData(currentPageIndex: Int?, datas: [RES]) async throws -> [DES] {
        fatalError()
    }
    
    public func onGetFooter() async throws -> [DES]? {
        return nil
    }
    
    public func onGetHeader() async throws -> [DES]? {
        return nil
    }
    
    public func onLoadStart(currentPageIndex: Int) async throws {
        
    }
    
    public func onLoading(currentPageIndex: Int, pageSize: Int) async throws -> PagingKBaseRes<RES> {
        fatalError()
    }
    
    public func onLoadFinished(currentPageIndex: Int, isResEmpty: Bool) async throws {
        
    }
    
    override func load(params: LoadParams<Int>) async -> LoadResult<Int, DES> {
        do {
            let currentPageIndex:Int = params.key ?? pagingConfig.pageIndexFirst
            let prevPageIndex:Int? = if currentPageIndex <= pagingConfig.pageIndexFirst {
                nil
            } else {
                currentPageIndex - 1
            }
            var nextPageIndex:Int? = nil
            //
            try await onLoadStart(currentPageIndex: currentPageIndex)
            //
            let pagingKRep = try await onLoading(currentPageIndex: currentPageIndex, pageSize: pagingConfig.pageSize)
            //
            var transformData:[DES]
            //
            if pagingKRep.isSuccessful() {
                let _data = pagingKRep.data
                if _data != nil {
                    let _currentPageItems = _data!.currentPageItems
                    if _currentPageItems?.isNullOrEmpty() == false {
                        var _totalPageNum = _data!.totalPageNum
                        if _totalPageNum<=0 {
                            let _totalItemNum = _data!.totalItemNum
                            //
                            _totalPageNum = _totalItemNum / pagingConfig.pageSize
                            if(_totalItemNum%pagingConfig.pageSize>0){
                                _totalPageNum += 1
                            }
                        }
                        //
                        nextPageIndex = if currentPageIndex >= _totalPageNum { nil } else { currentPageIndex+1 }
                        //加载基础数据
                        transformData = try await onTransformData(currentPageIndex: currentPageIndex, datas: _currentPageItems!)
                        //组合数据
                        try await onCombineData(currentPageIndex: currentPageIndex, datas: transformData)
                        //添加头部
                        let headers:[DES]? = try await onGetHeader()
                        if headers?.isNullOrEmpty() == false && currentPageIndex == pagingConfig.pageIndexFirst {
                            print("load: onGetHeader \(headers!)")
                            transformData.insert(contentsOf: headers!, at: 0)
                        }
                        //添加底部
                        let footers:[DES]? = try await onGetFooter()
                        if footers?.isNullOrEmpty() == false {
                            print("load: onGetFooter \(footers!)")
                            transformData.append(contentsOf: footers!)
                        }
                        //加载结束
                        try await onLoadFinished(currentPageIndex: currentPageIndex, isResEmpty: false)
                        //
                        return LoadResult<Int, DES>.Page(data: transformData, preKey: prevPageIndex, nextKey: nextPageIndex)
                    }
                }
            }
            //
            transformData = []
            //组合数据
            try await onCombineData(currentPageIndex: currentPageIndex, datas: transformData)
            //添加头部
            let headers:[DES]? = try await onGetHeader()
            if headers?.isNullOrEmpty() == false && currentPageIndex == pagingConfig.pageIndexFirst {
                print("load: onGetHeader \(headers!)")
                transformData.insert(contentsOf: headers!, at: 0)
            }
            //添加底部
            let footers:[DES]? = try await onGetFooter()
            if footers?.isNullOrEmpty() == false {
                print("load: onGetFooter \(footers!)")
                transformData.append(contentsOf: footers!)
            }
            //加载结束
            try await onLoadFinished(currentPageIndex: currentPageIndex, isResEmpty: true)
            //
            return LoadResult<Int,DES>.Page(data: transformData, preKey: prevPageIndex, nextKey: nextPageIndex)
        }catch{
            print(error)
            return LoadResult<Int,DES>.Wrong(error: error)
        }
    }
}
