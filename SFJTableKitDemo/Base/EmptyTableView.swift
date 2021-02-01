//
//  EmptyTableView.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/25.
//

import UIKit
import EmptyDataSet_Swift
import NVActivityIndicatorView

class BaseTableView: UITableView {
    
    private var p_emptyTitle: String?
    private var p_emptyVerticalOffset: CGFloat?
    private var p_emptyImage: UIImage?
    /// 过渡占位  loading
    private lazy var indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40), type: nil, color: .orange, padding: 5)
        return view
    }()
    
    /// 刷新状态
    private var status = EmptyViewStatus.loading {
        didSet {
            print(self.status)
            reloadEmptyDataSet()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        if enableEmpty {
            emptyDataSetSource = self
            emptyDataSetDelegate = self
        }
    }
}

extension BaseTableView: TableEmptyable {
    
    var enableEmpty: Bool {
        true
    }
    
    var emptyTitle: String {
        p_emptyTitle ?? "暂无数据"
    }
    
    var emptyVerticalOffset: CGFloat? {
        p_emptyVerticalOffset ?? nil
    }
    
    var emptyImage: UIImage? {
        switch status {
        case .loading:
            return nil
        case .normal:
            return p_emptyImage ?? UIImage(named: "placeholder_empty")
        case .error:
            return UIImage(named: "placeholder_error")
        }
    }
}

extension BaseTableView: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        emptyImage
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        switch status {
        case .loading:
            indicator.startAnimating()
            return indicator
        default:
            indicator.stopAnimating()
            return nil
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        switch status {
        case .error(let errStr):
            return NSAttributedString(string: errStr ?? "数据加载错误")
        default:
           return NSAttributedString(string: emptyTitle)
        }
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        guard let offset = emptyVerticalOffset else {
            return -frame.height * 0.2
        }
        return offset
    }
}
// MARK: - public api
extension BaseTableView {
    
    /// 主动loading
    func showLoading() {
        status = .loading
    }
    
    /// 主动普通空页面
    func showNormal() {
        status = .normal
    }
    
    /// 主动显示错误页面
    /// - Parameter err: 错误文案
    func showError(_ err: String) {
        status = .error(err)
    }
    
    func setEmptyTitle(_ title: String) {
        p_emptyTitle = title
    }
    
    func setEmptyVerticalOffset(_ offset: CGFloat) {
        p_emptyVerticalOffset = offset
    }
    
    func setEmptyImage(_ image: UIImage) {
        p_emptyImage = image
    }
}
