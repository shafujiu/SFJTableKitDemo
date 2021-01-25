//
//  EmptyTableViewController.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/25.
//

import UIKit
import SnapKit

class EmptyTableViewController: UIViewController {

    lazy var tableView: BaseTableView = {
        let view = BaseTableView(frame: .zero, style: .grouped)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }

    private func setupSubViews() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        tableView.showLoading()
//        // 加载错误
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
//            self.tableView.showError("加载错误")
//        }
        
        // 常规加载
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.tableView.showNormal()
        }
    }
    
}
