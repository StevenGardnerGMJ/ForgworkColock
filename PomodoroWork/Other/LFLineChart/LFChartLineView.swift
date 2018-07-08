//
//  LFChartLineView.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/7/6.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class LFChartLineView: LFAxisView {
    let valueArray = Array<CGFloat>()
    let  maxValue = CGFloat()
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
                let value = CGFloat(self.valueArray[i])
                let percent = value / self.maxValue;
                let point_Y = self.yAxis_L * CGFloat(1 - percent) + self.startPoint.y;
                
                let point = CGPoint(x: point_X, y: point_Y)
                
                
                // 记录各点的坐标方便后边添加渐变阴影 和 点击层视图 等
                pointArray.append(point)
                //        addObject:[NSValue valueWithCGPoint:point]];
                
                if (i == 0) {
                    pAxisPath.move(to: point)
                    //        moveToPoint:point];
                } else {
                    pAxisPath.addLine(to: point)
                    //        addLineToPoint:point];
                }
                
                let attributeValue = String(format: "%0.2f", value)
                let range = NSRange.init(attributeValue)
                let stingV = NSMutableAttributedString(string: attributeValue)
                stingV.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 9), range: range!)
                let size = stingV.size()
                
                // swift4.0之后使用[NSAttributedStringKey.font: UIFont.systemFont(ofSize: 9)]
                
                //            NSAttributedString(attributedString: String(format: "%0.2f", value))
                //            String(format: "%0.2f", value)
                
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: 10)
                let textLabel = UILabel.init(frame: rect)
                
                textLabel.font = UIFont.systemFont(ofSize: 9)
                textLabel.text = String(format: "%0.2f", value)
                //        [NSString stringWithFormat:@"%.2f",value];
                textLabel.center = CGPoint(x: point_X, y:  point_Y - 12.0)
                //        CGPointMake(point_X, point_Y - 12);
                self.addSubview(textLabel)
            }
        }
        
        let  pAxisLayer = CAShapeLayer()
        pAxisLayer.lineWidth = 1.0;
        pAxisLayer.strokeColor = UIColor.init(red: 54/255.0, green: 221/255.0, blue: 235/255.0, alpha: 1).cgColor
        //[UIColor colorWithRed:54/255.0 green:221/255.0 blue:235/255.0 alpha:1].CGColor;
        pAxisLayer.fillColor = UIColor.clear.cgColor
        pAxisLayer.path = pAxisPath.cgPath
        self.layer.addSublayer(pAxisLayer)
    }
    
    
    
    
    
}
