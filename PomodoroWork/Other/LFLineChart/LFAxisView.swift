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
    /// y 轴长度
    var  yAxis_L = CGFloat()
    /// x 轴长度
    var  xAxis_L = CGFloat()
    
    /// *  视图的宽度
    var axisViewWidth = CGFloat()
    /// *  视图的高度
    var axisViewHeight = CGFloat()
    
    /// * 与x轴平行的网格线的间距(与坐标系视图的高度和y轴刻度标签的个数相关)
    var yScaleMarkLEN = CGFloat()
    
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
        if(self.yMarkTitles.count == 1) {
            print("y轴只有一条数据")
            return;
        }
        if(self.xMarkTitles.count == 1) {
            print("x轴只有一条数据");
            return;
        }
        // 与x轴平行的网格线的间距
        let height = self.frame.size.height - YMARKLAB_HEIGHT - XMARKLAB_HEIGHT - YMARKLAB_TO_TOP
        let y_counts:CGFloat = CGFloat(self.yMarkTitles.count - 1)
        self.yScaleMarkLEN = height / y_counts
        
        self.yAxis_L = self.yScaleMarkLEN * y_counts
        
        
        // 视图的宽度
        let x_count = CGFloat(self.xMarkTitles.count - 1)
        let half_w:CGFloat = XMARKLAB_WIDTH / 2.0
        let width_U = self.axisViewWidth - HORIZON_YMARKLAB_YAXISLINE - YMARKLAB_WIDTH - half_w
        let width_p = HORIZON_YMARKLAB_YAXISLINE + YMARKLAB_WIDTH + half_w;
        if (self.xScaleMarkLEN == 0) {
            self.xScaleMarkLEN = width_U / x_count
        } else {
            axisViewWidth = self.xScaleMarkLEN * x_count + width_p
        }
        
        // x 轴长度
        self.xAxis_L = self.xScaleMarkLEN * x_count
        
        self.frame  = CGRect(x: 0, y: 0, width: axisViewWidth, height: axisViewHeight)
        
        self.setupYMarkLabs()
        self.setupXMarkLabs()
        
        self.drawYAxsiLine()
        self.drawXAxsiLine()
        
        self.drawYGridline()
        self.drawXGridline()

    }
    
    /// 更新做标注数据
    func  reloadDatas() {
        self.clearView()
        self.mapping()
    }
    
    
    //MARK:  -------- Y轴上的刻度标签 ---------
    func setupYMarkLabs() {
        
        for i in 0..<self.yMarkTitles.count {
            let i_y = CGFloat(i) * self.yScaleMarkLEN
            let y = CGFloat(self.startPoint.y - YMARKLAB_HEIGHT / 2.0 + i_y)
            let markLab = UILabel(frame: CGRect(x: 0, y: y, width: YMARKLAB_WIDTH, height: YMARKLAB_HEIGHT))
            
            markLab.textAlignment = .right
            markLab.font = UIFont.systemFont(ofSize: 12.0)
            
            let t = self.yMarkTitles.count - 1 - i
            let yString = self.yMarkTitles[t] as! String
            markLab.text = markLab.text! + yString
            
            // 隐去了y轴上的标签刻度
            self.addSubview(markLab)
        }
    }
    
    
    //MARK:      ----- X轴上的刻度标签  -----
    func setupXMarkLabs() {
        for  i in 0..<self.xMarkTitles.count {
            let x = self.startPoint.x - XMARKLAB_WIDTH / 2 + CGFloat(i) * self.xScaleMarkLEN
            let y = self.yAxis_L + self.startPoint.y + YMARKLAB_HEIGHT / 2.0
            
            let markLab = UILabel(frame: CGRect(x: x, y: y, width: XMARKLAB_WIDTH, height: XMARKLAB_HEIGHT))
            
            markLab.textAlignment = .center
            markLab.font = UIFont.systemFont(ofSize: 11.0)
            markLab.text = (self.xMarkTitles[i] as! String)
            self.addSubview(markLab)
        }
    }
    
    
    //MARK:  -------------- Y轴 -------------
    func drawYAxsiLine() {
        let yAxisPath = UIBezierPath()
        yAxisPath.move(to: CGPoint(x: self.startPoint.x, y: self.startPoint.y + self.yAxis_L))
        yAxisPath.addLine(to: CGPoint(x: self.startPoint.x, y: self.startPoint.y))
        let yAxisLayer = CAShapeLayer()
        
        // 设置线为虚线
        let number1 = NSNumber(value: 1)
        let number2 = NSNumber(value: 1.5)
        let array = [number1,number2]
        yAxisLayer.lineDashPattern?.append(contentsOf: array)
        yAxisLayer.lineWidth = 0.5;
        yAxisLayer.strokeColor = UIColor.red.cgColor
        yAxisLayer.path = yAxisPath.cgPath;
//        self.layer.addSublayer(yAxisLayer)
    }
    
    //MARK:  --------- X轴 --------------
    func drawXAxsiLine() {
        let xAxisPath = UIBezierPath()
        xAxisPath.move(to: CGPoint(x: self.startPoint.x, y: self.yAxis_L + self.startPoint.y))
        
        xAxisPath.addLine(to: CGPoint(x: self.xAxis_L + self.startPoint.x, y: self.yAxis_L + self.startPoint.y))
        
        let number1 = NSNumber(value: 1)
        let number2 = NSNumber(value: 1.5)
        let array = [number1,number2]
        let xAxisLayer = CAShapeLayer()
        xAxisLayer.lineDashPattern?.append(contentsOf: array)
        
        xAxisLayer.lineWidth = 0.5;
        xAxisLayer.strokeColor = UIColor.red.cgColor
        xAxisLayer.path = xAxisPath.cgPath
//        self.layer.addSublayer(xAxisLayer)
    }
    
    //mark:  --------  与 Y轴 平行的网格线  ---------
    func drawYGridline() {
        for  i in 0..<self.xMarkTitles.count-1 {
            
            let curMark_X = self.startPoint.x + self.xScaleMarkLEN * CGFloat(i + 1);
            
            let yAxisPath = UIBezierPath()
            yAxisPath.move(to: CGPoint(x: curMark_X, y: self.yAxis_L + self.startPoint.y))
            
            yAxisPath.addLine(to: CGPoint(x: curMark_X, y: self.startPoint.y))
            
            let yAxisLayer = CAShapeLayer()
            
            let number1 = NSNumber(value: 1)
            let number2 = NSNumber(value: 1.5)
            let array = [number1,number2]
            
            yAxisLayer.lineDashPattern?.append(contentsOf: array)// 设置线为虚线
            yAxisLayer.lineWidth = 0.5;
            yAxisLayer.strokeColor = UIColor.black.cgColor;
            yAxisLayer.path = yAxisPath.cgPath
//            self.layer.addSublayer(yAxisPath)
        }
    }
    
    
    //MARK:  ----- 与 X轴 平行的网格线 --------
    func drawXGridline() {
        for  i in 0..<self.yMarkTitles.count - 1 {
            
            let curMark_Y = self.yScaleMarkLEN * CGFloat(i)
            
            let xAxisPath = UIBezierPath()
            xAxisPath.move(to: CGPoint(x: self.startPoint.x, y: curMark_Y + self.startPoint.y))
            
            xAxisPath.addLine(to: CGPoint(x: self.startPoint.x + self.xAxis_L, y: curMark_Y + self.startPoint.y))
            
            
            let xAxisLayer = CAShapeLayer()
            let number1 = NSNumber(value: 1)
            let number2 = NSNumber(value: 1.5)
            let array = [number1,number2]
            xAxisLayer.lineDashPattern?.append(contentsOf: array)
            xAxisLayer.lineWidth = 0.5;
            xAxisLayer.strokeColor = UIColor.black.cgColor;
            xAxisLayer.path = xAxisPath.cgPath
            self.layer.addSublayer(xAxisLayer)
        }
    }
    //mark- 清空视图
   func clearView() {
    
    removeAllSubLabs()
    removeAllSubLayers()
    }
    // mark 清空标签
    func removeAllSubLabs() {
    
        let subviews = self.subviews as Array<UIView>
//        [NSArray arrayWithArray:self.subviews];
    
    for view in subviews {
      view.removeFromSuperview()
//        (view as AnyObject).removeFromSuperview()
    }
    }
    
    //mark: 清空网格线
    func removeAllSubLayers() {
    
        let subLayers = self.layer.sublayers!
    for layer in subLayers {
        layer.removeAllAnimations()
        layer.removeFromSuperlayer()
        
    }
    }



    
    
    
    
    
    

}










