//
//  EmptyViewStatus.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/20.
//

import Foundation

enum EmptyViewStatus {
    case loading
    case normal
    case error(String?)
}

//enum CompletionResult: SwiftResult {
////    case success
////    case failure(_ error: Swift.Error)
//}

typealias Completion = (Result<Bool, Swift.Error>)->()

protocol TableViewActions {
    func loadDataAction(_ complate: Completion?)
    func loadMoreDataAction(_ complate: Completion?)
}

extension TableViewActions {
    
    func loadDataAction(_ complate: Completion?) {
        
    }
    func loadMoreDataAction(_ complate: Completion?) {
        
    }
}


protocol TableProtocol: TableViewActions {
    
    /// 是否有空页面
    var enableEmpty: Bool { get }
    /// 是否下拉刷新
    var enableRefreshHeader: Bool { get }
    /// 是否上拉加载
    var enableRefreshFooter: Bool { get }
    
    var emptyTitle: String { get }
    var emptyImage: UIImage? { get }
//    var emptyDataSetShouldDisplay: Bool? { get }
//    var emptyTapAction: (()->())? { get }
}

extension TableProtocol {
    var enableEmpty: Bool { true }
    var enableRefreshHeader: Bool { true }
    var enableRefreshFooter: Bool { true }
    var emptyTitle: String { "暂无数据" }
    var emptyImage: UIImage? { nil }
    var emptyTapAction: (()->())? {
        nil }
//    var emptyDataSetShouldDisplay: Bool? { nil }
}
