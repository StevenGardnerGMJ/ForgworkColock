//
//  RoundedButton.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/9.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
//    let defaultColor = UIColor(red: 240/255, green: 90/255, blue: 90/255, alpha: 1)
    // 修改为绿色
    let highlightedColor = UIColor(red: 92/255, green: 184/255, blue: 92/255, alpha: 1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 8
//        layer.backgroundColor = defaultColor.cgColor
    }
    
//    override var isHighlighted: Bool {
//        didSet {
//            if isHighlighted {
//                layer.backgroundColor = highlightedColor.cgColor
//            } else {
//                layer.backgroundColor = defaultColor.cgColor
//            }
//        }
//    }
    
}



