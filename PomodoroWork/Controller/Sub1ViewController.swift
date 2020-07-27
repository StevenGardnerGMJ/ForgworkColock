//
//  Sub1ViewController.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/8/2.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class Sub1ViewController: SubViewController {
    
    let lineChart = LFLineChart()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setView() {
        lineChart.frame = CGRect(x: 10, y: 80, width: view.bounds.width-20, height: view.bounds.height*3/5)
        lineChart.backgroundColor = UIColor.white
        lineChart.title = "身体数据指标-体重"
        var orderArray = Array<Dictionary<String, CGFloat>>()
        var  max:CGFloat = 0 // 定义Y value 最大值
        var  maxY:CGFloat = 0 // 定义 Y 坐标轴最大值
        for i in 0..<24 {
            var dic = Dictionary<String, CGFloat>()
            var xValue = CGFloat()
            var yValue = CGFloat()
            if i<10 {
                xValue = CGFloat(i) // "0\(i)" 横轴坐标 01 02 ...
            } else {
                xValue = CGFloat(i) //  "\(i)" 11 12 ...
            }
            yValue = CGFloat(arc4random() % 10+100 ) // y轴数值随机
            
            
            if yValue > max {
                max = yValue
                maxY = max*7/5 // Y 刻度轴多余显示效果更好
            }
            dic = ["item":xValue, "count":yValue]
            orderArray.append(dic)
        }
        
        lineChart.maxValue = maxY // 刻度轴
        if max ==  0 {
            lineChart.maxValue = 5 // 给默认值
        }
        lineChart.xScaleMarkLEN = 50// x轴间隔宽度
        
        
        // Y轴刻度标签 0~~ 7/5 Y轴
        lineChart.yMarkTitles = ["0",
      String(format:"%.2f",max/5.0),
      String(format:"%.2f",max*2/5),
      String(format:"%.2f",max*3/5),
      String(format:"%.2f",max*4/5),
      String(format:"%.2f",max*5/5),
      String(format:"%.2f",max*6/5),
      String(format:"%.2f",max*7/5)]
        
        // X轴刻度标签及相应的值
        lineChart.setXMarkTitlesAndValues(xMarkTitlesAndValues: orderArray as! Array<Dictionary<String, CGFloat>>, titleKey: "item", valueKey: "count")
        // 绘图折线图
        lineChart.mapping()
        view.addSubview(lineChart)
        
        //头顶上的时间标志
        let unitLabel = UILabel(frame: CGRect(x: 20, y: 90, width: 100, height: 15))
        unitLabel.text = "HHmg"
        unitLabel.textColor = UIColor.lightGray
        unitLabel.font = UIFont.systemFont(ofSize: 15.0)
        view.addSubview(unitLabel)
        
    }
    

}








