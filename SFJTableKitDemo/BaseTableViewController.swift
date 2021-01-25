//
//  BaseTableViewController.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/20.
//

import UIKit
import EmptyDataSet_Swift
import SnapKit
import NVActivityIndicatorView

class BaseTableViewController<T>: UIViewController {
    
    var data: [T] = []
    // 是否初始刷新过
    private var initialRefreshed = false
    /// 刷新状态
    private var status = EmptyViewStatus.loading {
        didSet {
            print(self.status)
            tableView.reloadEmptyDataSet()
        }
    }
    /// 过渡占位  loading
    private lazy var indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40), type: nil, color: .orange, padding: 5)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        // 位置设置
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }

        tableView.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        if (self as? TableEmptyable)?.enableEmpty ?? false {
            tableView.emptyDataSetSource = self
            tableView.emptyDataSetDelegate = self
        }
        
        if (self as? TableViewRefreshable)?.enableRefreshHeader ?? false {
            tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                self?.refreshHeaderAction()
            })
        }
    }
}
// MARK: - public api
extension BaseTableViewController {
    func loadData() {
        refreshHeaderAction()
    }
}
// MARK: - private api
extension BaseTableViewController {
    
    /// MJHeader 事件
    /// - Parameter force: 是否强制刷新（）
    private func refreshHeaderAction() {
        status = .loading
        tableView.mj_footer = nil
        initialRefreshed = true

        //        if shouldDisplay {
        (self as? TableViewRefreshable)?.loadDataAction({[weak self] in
            guard let `self` = self else {return}
            switch $0 {
            case .success(let noMoreData):
                if !self.initialRefreshed, self.data.count == 0 {
                    self.status = .loading
                } else {
                    self.status = .normal
                    self.addFooter()
                    if noMoreData {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                self.tableView.reloadData()
            case .failure(let err):
                self.data = []
                // hud
                //
                self.status = .error(err.localizedDescription)
            }
            self.tableView.mj_header?.endRefreshing()
        })
    }
    
    /// MJFooter 事件
    private func refreshFooterAction() {
        (self as? TableViewRefreshable)?.loadMoreDataAction({ [weak self] in
            switch $0 {
            case .success(let noMoreData):
                self?.tableView.reloadData()
                if noMoreData {
                    self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            case .failure(_):
                // hud
                //
                self?.tableView.mj_footer?.endRefreshing()
            }
        })
    }
    
    /// 首次 加载数据是不需要footer
    private func addFooter() {
        if (self as? TableViewRefreshable)?.enableRefreshFooter ?? false,
           tableView.mj_footer == nil, data.count > 0 {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
                self?.refreshFooterAction()
            })
            tableView.mj_footer = footer
        }
    }
    
    // MARK: - private empty
    
    /// 空页面图片
    /// - Returns: UIImage
    /// - description: 需要注意的是，loading状态不需要图，展示的是customView
    private func emptyImage() -> UIImage? {
        switch status {
        case .loading:
            return nil
        case .normal:
            return UIImage(named: "placeholder_empty")
        case .error:
            return UIImage(named: "placeholder_error")
        }
    }
    
    func forceDisplay() -> Bool {
        (self as? TableEmptyable)?.emptyForcedToDisplay ?? false
    }
}

extension BaseTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        if let image = (self as? TableEmptyable)?.emptyImage {
            return image
        } else {
            return emptyImage()
        }
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        switch status {
        case .loading:
            indicator.startAnimating()
            return indicator
        default:
            indicator.stopAnimating()
            return (self as? TableEmptyable)?.emptyCustomView ?? nil
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        switch status {
        case .error(let errStr):
            return NSAttributedString(string: errStr ?? "数据加载错误")
        default:
            if let title = (self as? TableEmptyable)?.emptyTitle {
                return NSAttributedString(string: title)
            } else {
                return NSAttributedString(string: "暂无数据")
            }
        }
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        guard let offset = (self as? TableEmptyable)?.emptyVerticalOffset else {
            return -tableView.frame.height * 0.2
        }
        return offset
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        true
    }
    
    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool {
        forceDisplay()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let emptyAction = (self as? TableEmptyable)?.emptyTapAction  else {
            loadData()
            return
        }
        emptyAction()
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        switch status {
        case .loading:
            return false
        default:
            return true
        }
    }
}

