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
        
        if (self as? TableProtocol)?.enableEmpty ?? false {
            tableView.emptyDataSetSource = self
            tableView.emptyDataSetDelegate = self
        }
        
        if (self as? TableProtocol)?.enableRefreshHeader ?? false {
            tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                self?.refreshHeaderAction()
            })
        }
    }
}
// MARK: - public api
extension BaseTableViewController {
    func loadData(_ force: Bool = true) {
        refreshHeaderAction(force)
    }
}
// MARK: - private api
extension BaseTableViewController {
    
    /// MJHeader 事件
    /// - Parameter force: 是否强制刷新（）
    private func refreshHeaderAction(_ force: Bool = true) {
        status = .loading
        tableView.mj_footer = nil
        initialRefreshed = true
        
        if data.count == 0 || force {
            (self as? TableProtocol)?.loadDataAction({[weak self] in
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
    }
    
    /// MJFooter 事件
    private func refreshFooterAction() {
        (self as? TableProtocol)?.loadMoreDataAction({ [weak self] in
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
        if (self as? TableProtocol)?.enableRefreshFooter ?? false,
           tableView.mj_footer == nil, data.count > 0{
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
    
    
}

extension BaseTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        if let image = (self as? TableProtocol)?.emptyImage {
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
            return nil
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        switch status {
        case .error(let errStr):
            return NSAttributedString(string: errStr ?? "数据加载错误")
        default:
            if let title = (self as? TableProtocol)?.emptyTitle {
                return NSAttributedString(string: title)
            } else {
                return NSAttributedString(string: "暂无数据")
            }
        }
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        true
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        (data.count == 0)
//        return (self as? TableProtocol)?.emptyDataSetShouldDisplay ?? (data.count == 0)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        (self as? TableProtocol)?.emptyTapAction?()
        loadData()
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

