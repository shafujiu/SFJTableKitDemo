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
        loadData(true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SFJFlatTableViewController: TableEmptyable, TableViewRefreshable {
    
    var enableLoadingPlace: Bool {
        false
    }
    
    var emptyTitle: String {
        "******"
    }
    
    var emptyForcedToDisplay: Bool? {
        data.count == 1
    }

    var enableRefreshFooter: Bool {
        data.count > 1
    }
    
    var customView: UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .orange
        return view
    }
    
    func loadDataAction(_ complate: @escaping Completion) {
        // 模拟加载数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let arr = [1,2,3,4,5,6,7,8,9,10]
            self.data = [1]
            let noMoreData = true
            complate(.success(noMoreData))
//            let err = NSError(domain: "获取数据失败", code: 100, userInfo: nil)
//            complate?(.failure(err))
        }
    }
 
    
    func loadMoreDataAction(_ complate: @escaping Completion) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let arr = [1,2,3,4,5,6,7,8,9,10]
            self.data += arr
            
            let noMoreData = false
            complate(.success(noMoreData))
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
