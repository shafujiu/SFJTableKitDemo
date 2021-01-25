//
//  EmptyScollViewController.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/25.
//

import UIKit

class EmptyScollViewController: UIViewController {

    private lazy var scrollView: BaseScrollView = {
        let view = BaseScrollView()
        return view
    }()
    
    private var shouldShow: Bool = true // 自定义显示规则
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.setEmptyShouldDisplay { () -> (Bool) in
            return self.shouldShow
        }
    }
    
    

}
