//
//  EmptyRoundedButton.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/9.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class EmptyRoundedButton: UIButton {
    
    let defaultColor = UIColor(red: 92/255, green: 184/255, blue: 92/255, alpha: 1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 定义 默认值
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = defaultColor.cgColor
    }
    
//    func highlight() {
//        layer.backgroundColor = defaultColor.cgColor
//    }
    
//    func removeHighlight() {
//        layer.backgroundColor = UIColor.clear.cgColor
//    }
    
    // Btn setHighlight 效果
//    override var isHighlighted: Bool {
//        didSet {
//            if isHighlighted {
//                highlight()
//            } else {
//                removeHighlight()
//            }
//        }
//    }
    
}











