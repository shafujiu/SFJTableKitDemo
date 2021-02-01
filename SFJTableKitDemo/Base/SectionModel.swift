//
//  SectionModel.swift
//  SFJTableKitDemo
//
//  Created by Shafujiu on 2021/1/26.
//

import UIKit

class SectionModel<H, T> {
    var header: H?
    var data: [T] = []
    
    
    convenience init(header: H?, data: [T]) {
        self.init()
        self.header = header
        self.data = data
    }
}
