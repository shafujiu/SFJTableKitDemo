//
//  GroupTableViewController.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/26.
//

import UIKit

/// 使用的时候 如果需要空页面 注意空页面强制显示规则
class GroupTableViewController<S, H, D>: BaseTableViewController<S> where S: SectionModel<H, D> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
