//
//  LFCircleView.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/7/2.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class LFCircleView: UIView {

    var borderWidth = CGFloat()
    var borderColor = UIColor()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithCenter(center:CGPoint,radius:CGFloat)->LFCircleView {
        self.frame = CGRect(x: center.x-radius, y: center.y-radius, width: radius*2.0, height: radius*2.0)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        return self
    }
    override func layoutSubviews() {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    

    
}




