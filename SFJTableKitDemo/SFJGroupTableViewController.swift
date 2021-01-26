//
//  SFJGroupTableViewController.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/26.
//

import UIKit

class SFJGroupSectionModel: SectionModel<String, Int> {
    
}

class SFJGroupTableViewController: GroupTableViewController<SFJGroupSectionModel, String, Int> {

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

extension SFJGroupTableViewController: TableViewRefreshable{
    
    func loadDataAction(_ complate: @escaping Completion) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.data = [SFJGroupSectionModel(header: "1", data: [1,2,3,4]),
                         SFJGroupSectionModel(header: "2", data: [1,2,3,4]),
                         SFJGroupSectionModel(header: "3", data: [1,2,3,4]),
                         SFJGroupSectionModel(header: "4", data: [1,2,3,4])]
            
            self.data = [SFJGroupSectionModel(header: "1", data: [1])]
            complate(.success(true))
        }
    }
    
    func loadMoreDataAction(_ complate: @escaping Completion) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.data = [SFJGroupSectionModel(header: "1", data: [1,2,3,4]),
                         SFJGroupSectionModel(header: "2", data: [1,2,3,4]),
                         SFJGroupSectionModel(header: "3", data: [1,2,3,4]),
                         SFJGroupSectionModel(header: "4", data: [1,2,3,4])]
            complate(.success(true))
        }
    }
    
}

extension SFJGroupTableViewController: TableEmptyable {
    
    /// 重写 强制显示规则
    var emptyForcedToDisplay: Bool? {
        data.count == 1 && data.first?.data.count == 1
    }
    
}



extension SFJGroupTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "这是第\(indexPath.section)组，第\(indexPath.row), content = \(self.data[indexPath.section].data[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
