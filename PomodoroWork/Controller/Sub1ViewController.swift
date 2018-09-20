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
        lineChart.title = "身体数据指标"
        var orderArray = Array<Dictionary<String, CGFloat>>()
        var  max:CGFloat = 0
        for i in 0..<24 {
            var dic = Dictionary<String, CGFloat>()
            var xValue = CGFloat()
            var yValue = CGFloat()
            if i<10 {
                xValue = CGFloat(i) // "0\(i)" 横轴坐标 01 02 ...
            } else {
                xValue = CGFloat(i) //  "\(i)" 11 12 ...
            }
            yValue = CGFloat(arc4random() % 100) // y轴数值随机
            
            
            if yValue > max {
                max = yValue
            }
            dic = ["item":xValue, "count":yValue]
            orderArray.append(dic)
        }
        
        lineChart.maxValue = CGFloat(max)
        if max ==  0 {
            lineChart.maxValue = 5 // 给默认值
        }
        lineChart.xScaleMarkLEN = 20// x轴间隔宽度
        
        
        // Y轴刻度标签
        lineChart.yMarkTitles = ["0",String(format:"%.2f",max/5.0),String(format:"%.2f",max*2/5),String(format:"%.2f",max*3/5),String(format:"%.2f",max*4/5),String(format:"%.2f",max*5/5)]
        
        // X轴刻度标签及相应的值
        lineChart.setXMarkTitlesAndValues(xMarkTitlesAndValues: orderArray as! Array<Dictionary<String, CGFloat>>, titleKey: "item", valueKey: "count")
        // 绘图折线图
        lineChart.mapping()
        view.addSubview(lineChart)
        
        //头顶上的时间标志
        let unitLabel = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 15))
        
        unitLabel.text = "电里"
        unitLabel.textColor = UIColor.lightGray
        unitLabel.font = UIFont.systemFont(ofSize: 15.0)
        view.addSubview(unitLabel)
        
    }
    

    
    

}








