//
//  DataSource.swift
//  IPagingKit.Pagination
//
//  Created by Taiyou on 2025/7/22.
//

protocol DataSource: AnyObject {
    /// Label for source type (e.g. Grade for grades loading). Used in loading text.
//    var label: String { get }
    /// Should start with .nextPageFound
    var loadingState: LoadingState { get set }
    var pageMode: PageMode { get set }

    func fetchNextPage() async
}

enum LoadingState: Equatable {
    case idle /// To stop querying for pages - if no more exist
    case nextPageReady /// To fetch new page the next time we scroll down
    case error(_ reason: String = "")
    case loading /// Can't query anything during this
}

enum PageMode {
    case offline, live
}

extension DataSource {
    @MainActor
    func setLoadingState(_ state: LoadingState) {
        self.loadingState = state
    }

    @MainActor
    func setPageMode(_ mode: PageMode) {
        self.pageMode = mode
    }
}
