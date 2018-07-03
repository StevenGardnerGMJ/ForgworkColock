//
//  LFAxisView.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/7/2.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit


let HORIZON_YMARKLAB_YAXISLINE:CGFloat = 10.0
let YMARKLAB_WIDTH:CGFloat = 20.0
let YMARKLAB_HEIGHT:CGFloat = 16.0
let XMARKLAB_WIDTH:CGFloat = 40.0
let XMARKLAB_HEIGHT:CGFloat = 16.0
let YMARKLAB_TO_TOP:CGFloat = 12.0

class LFAxisView: UIView {

    /// Y轴刻度标签
    var  yMarkTitles = NSArray()
    /// X轴刻度标签
    var  xMarkTitles = NSArray()
    /// 与x轴平行的网格线的间距
    var  xScaleMarkLEN = CGFloat()
    /// 网格线的起始点
    var  startPoint = CGPoint()
    /// x 轴长度
    var  yAxis_L = CGFloat()
    /// y 轴长度
    var  xAxis_L = CGFloat()
    
    /// *  视图的宽度
    var axisViewWidth = CGFloat()
    /// *  视图的高度
    var axisViewHeight = CGFloat()
    /// * 与x轴平行的网格线的间距(与坐标系视图的高度和y轴刻度标签的个数相关)
    let yScaleMarkLEN = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axisViewHeight = frame.size.height
        axisViewWidth = frame.size.width
       let start_X = HORIZON_YMARKLAB_YAXISLINE + YMARKLAB_WIDTH
       let start_Y = YMARKLAB_HEIGHT / 2.0 + YMARKLAB_TO_TOP
       self.startPoint = CGPoint(x: start_X, y: start_Y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 绘图
    func mapping() {
    
    }
    
    /// 更新做标注数据
    func  reloadDatas(){
        
    }

}
