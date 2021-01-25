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

protocol TableViewRefreshable {
    /// 是否下拉刷新
    var enableRefreshHeader: Bool { get }
    /// 是否上拉加载
    var enableRefreshFooter: Bool { get }
    
    func loadDataAction(_ complate: @escaping Completion)
    func loadMoreDataAction(_ complate: @escaping Completion)
}

extension TableViewRefreshable {
    var enableRefreshHeader: Bool { true }
    var enableRefreshFooter: Bool { true }
    
    func loadDataAction(_ complate: Completion) {}
    func loadMoreDataAction(_ complate: Completion) {}
}

protocol TableEmptyable {
    
    /// 是否有空页面
    var enableEmpty: Bool { get }
    var emptyVerticalOffset: CGFloat? { get }
    var emptyTitle: String { get }
    var emptyImage: UIImage? { get }
    
    /// 自定义空页面 ； emptyImage，emptyTitle与 emptyCustomView同时存在的时候 emptyCustomView优先
    var emptyCustomView: UIView? { get }
    
    /// 重写强制展示空页面规则
    var emptyForcedToDisplay: Bool? { get }
    var emptyTapAction: (()->())? { get }
}

extension TableEmptyable {
    
    var enableEmpty: Bool { true }
    var emptyVerticalOffset: CGFloat? {
        nil
    }
    var emptyTitle: String { "暂无数据" }
    var emptyImage: UIImage? { nil }
    var emptyCustomView: UIView? { nil }
    
    var emptyForcedToDisplay: Bool? { nil }
    var emptyTapAction: (()->())? {
        nil }
}
