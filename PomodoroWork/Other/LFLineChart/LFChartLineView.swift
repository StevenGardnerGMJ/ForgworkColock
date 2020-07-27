//
//  LFChartLineView.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/7/6.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class LFChartLineView: LFAxisView {
    var  valueArray = Array<CGFloat>()
    var  maxValue   = CGFloat()
    var  pointArray = Array<CGPoint>()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.yAxis_L = frame.size.height;
        self.xAxis_L = frame.size.width;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mapping(){
        
        super.mapping()
        
        self.drawChartLine()
        self.drawGradient()
        self.setupCircleViews()
        
    }
    override func reloadDatas(){
        self.clearView()
        self.mapping()
    }
    
    //  mark 画折线图
    func drawChartLine() {
        
        if pointArray.isEmpty == false  {
            pointArray.removeAll()
        } else {
            pointArray = [CGPoint]()
            print("capacity = \(pointArray.capacity)")
        }
        
        let pAxisPath = UIBezierPath()
        
        for  i in 0..<self.valueArray.count {
            if (CGFloat(self.valueArray[i]) != -1) {
                let point_X = self.xScaleMarkLEN * CGFloat(i) + self.startPoint.x;
                //         CGFloat point_X = self.xScaleMarkLEN * i;
                let value   = CGFloat(self.valueArray[i])
                let percent = value / self.maxValue;
                let point_Y = self.yAxis_L * CGFloat(1 - percent) + self.startPoint.y;
                
                let point = CGPoint(x: point_X, y: point_Y)
                // 记录各点的坐标方便后边添加渐变阴影 和 点击层视图 等
                pointArray.append(point)
                
                if (i == 0) {
                    pAxisPath.move(to: point)
                } else {
                    pAxisPath.addLine(to: point)
                }
                
                let str =  String(format: "%0.2f", value)//NSString(string: "\(value)")
                let strAttribute = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 9.0)]
                
                let size = str.size(withAttributes: strAttribute)
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: 10)
                let textLabel = UILabel.init(frame: rect)
                
                textLabel.font = UIFont.systemFont(ofSize: 9)
                textLabel.text = String(format: "%0.2f", value)
                //        [NSString stringWithFormat:@"%.2f",value];
                textLabel.center = CGPoint(x: point_X, y:  point_Y - 12.0)
                self.addSubview(textLabel)
            }
        }
        
        let  pAxisLayer = CAShapeLayer()
        pAxisLayer.lineWidth = 1.0;
        pAxisLayer.strokeColor = UIColor.init(red: 54/255.0, green: 221/255.0, blue: 235/255.0, alpha: 1).cgColor
        pAxisLayer.fillColor = UIColor.clear.cgColor
        pAxisLayer.path = pAxisPath.cgPath
        self.layer.addSublayer(pAxisLayer)
    }
    
    
    // MARK:   渐变阴影
    func drawGradient() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        gradientLayer.colors = [UIColor.init(red: 54/255.0, green: 221/255.0, blue: 235/255.0, alpha: 1).cgColor,UIColor.init(white: 1, alpha: 0.1).cgColor]
    
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x:0.0, y:1)
        
        let gradientPath = UIBezierPath()
        gradientPath.move(to: CGPoint(x: self.startPoint.x, y: self.yAxis_L + self.startPoint.y))
        
        for  i in 0..<pointArray.count {
            let point = pointArray[i]
            gradientPath.addLine(to: point)
        }
        
        var endPoint:CGPoint = pointArray.last!
        endPoint = CGPoint(x: endPoint.x, y: self.yAxis_L + self.startPoint.y)
        gradientPath.addLine(to: endPoint)
        
        let arc = CAShapeLayer()
        arc.path = gradientPath.cgPath
        gradientLayer.mask = arc;
        self.layer.addSublayer(gradientLayer)
    }
    
    //MARK: -------- 折线上的圆环
    func setupCircleViews() {
        
        for  i in 0..<pointArray.count {
            
            let circleView = LFCircleView().initWithCenter(center: pointArray[i], radius: 4.0)

            circleView.borderColor = UIColor.init(red: 54/255.0, green: 221/255.0, blue: 235/255.0, alpha: 1)
            //        colorWithRed:54/255.0 green:221/255.0 blue:235/255.0 alpha:1];
            circleView.borderWidth = 1.0;
            self.addSubview(circleView)
        }
    }
    
    //MARK:  --- 清空视图 --- 
    override func clearView() {
        self.removeSubviews()
        self.removeSublayers()
    }
    
    //MARK: ------ 移除 点击图层 、圆环 、数值标签 ----
    func removeSubviews() {
        
        let subViews = self.subviews as Array<UIView>
        for view in subViews {
            view.removeFromSuperview()
        }
        
    }
    
    //MARK: ---------- 移除折线 ----------
    func removeSublayers() {
        let subLayers = self.layer.sublayers!
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
    
}






