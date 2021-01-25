//
//  SFJFlatTableViewController.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/21.
//

import UIKit

class SFJFlatTableViewController: FlatTableViewController<Int> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SFJFlatTableViewController: TableProtocol {
    
    var enableRefresh: Bool {
        true
    }
    
    var emptyTitle: String {
        "******"
    }
    
//    var emptyDataSetShouldDisplay: Bool? {
//        // 自己设定规则， 以决定是否显示
//        if data.count == 10 {
//            return true
//        }else {
//            return false
//        }
//    }
    
    func loadDataAction(_ complate: Completion?) {
        // 模拟加载数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let arr = [1,2,3,4,5,6,7,8,9,10]
            self.data = arr
            
            let noMoreData = true
            complate?(.success(noMoreData))
//            let err = NSError(domain: "获取数据失败", code: 100, userInfo: nil)
//            complate?(.failure(err))
        }
    }
    
    func loadMoreDataAction(_ complate: Completion?) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let arr = [1,2,3,4,5,6,7,8,9,10]
            self.data += arr
            
            let noMoreData = false
            complate?(.success(noMoreData))
        }
    }
    
}

extension SFJFlatTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "this is \(data[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
