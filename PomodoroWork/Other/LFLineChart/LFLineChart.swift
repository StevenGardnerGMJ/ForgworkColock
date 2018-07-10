//
//  LFLineChart.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/7/5.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class LFLineChart: UIView {
    /// 表名
    var title = String()
    /// Y轴刻度标签title
    var yMarkTitles = Array<Any>()
    /// Y轴最大值
    var maxValue = CGFloat()
    /// X轴刻度标签的长度（单位长度）
    var xScaleMarkLEN = CGFloat()
    
    //MARK:  ---------- LineChar 界面 -------------------
    
    var xMarkTitles = Array<Any>()
    var valueArray  = Array<Any>()
    
    var titleLab = UILabel()
    var scrollView = UIScrollView()
    var chartLineView = LFChartLineView()
    var xMarkTitlesAndValues = Array<Dictionary<String, Any>>()
    
    
    
    
    
    
    
    
    
    /// 设置折线图显示的数据和对应X坐标轴刻度标签
    ///
    /// - Parameters:
    ///   - xMarkTitlesAndValues: 折线图显示的数据和X坐标轴刻度标签
    ///   - titleKey: 标签（如:9月1日）
    ///   - valueKey: 数据 (如:80)
    func setXMarkTitlesAndValues(xMarkTitlesAndValues:Array<Dictionary<String, Any>>, titleKey:String, valueKey:String){
        
        self.xMarkTitlesAndValues = xMarkTitlesAndValues
        
        if xMarkTitles.isEmpty == false {
            xMarkTitles.removeAll()
        }
        else {
            xMarkTitles = Array<Any>()
            
        }
        
        if (valueArray.isEmpty == false) {
            valueArray.removeAll()
        }
        else {
            valueArray = Array<Any>()
                //[NSMutableArray arrayWithCapacity:0];
        }
        
        for dic in xMarkTitlesAndValues {
            let titleKey_value = dic["\(titleKey)"]
            xMarkTitles.append(titleKey_value)
            //addObject:[dic objectForKey:titleKey]];
            let valueKey_value = dic["\(valueKey)"]
            valueArray.append(valueKey_value)
            //addObject:[dic objectForKey:valueKey]];
        }
        
    }
    
    func mapping() {
        var topToContainView:CGFloat = 0.0
        
        if (self.title.isEmpty == false) {
            
            self.titleLab = UILabel.init(frame: CGRect(x: 0, y: 5, width:self.frame.width, height: 20))
//                [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.frame), 20)];
            self.titleLab.text = self.title;
            self.titleLab.font = UIFont.systemFont(ofSize: 15)
            self.titleLab.textAlignment = .center
            self.addSubview(self.titleLab)
                //addSubview:self.titleLab];
            topToContainView = 25;
        }
        
        if (self.xMarkTitlesAndValues.isEmpty == true) {
            
            xMarkTitles = [1,2,3,4,5]
            valueArray  = [2,2,2,2,2]
            
//            NSLog(@"折线图需要一个显示X轴刻度标签的数组xMarkTitles");
//            NSLog(@"折线图需要一个转折点值的数组valueArray");
        }
        
        
        if (self.yMarkTitles.isEmpty ==  true) {
            self.yMarkTitles = [0,1,2,3,4,5]
//            NSLog(@"折线图需要一个显示Y轴刻度标签的数组yMarkTitles");
        }
        
        
        if (self.maxValue == 0) {
            self.maxValue = 5;
//            NSLog(@"折线图需要一个最大值maxValue");
            
        }
        
        self.scrollView = UIScrollView.init(frame: CGRect(x: 0, y: topToContainView, width: self.frame.size.width, height: self.frame.size.height - topToContainView))
        //initWithFrame:CGRectMake(0, topToContainView, self.frame.size.width,self.frame.size.height - topToContainView)];
        self.scrollView.showsVerticalScrollIndicator = false
//        setShowsHorizontalScrollIndicator:NO];
        self.scrollView.showsHorizontalScrollIndicator = false
//            setShowsVerticalScrollIndicator:NO];
        self.addSubview(self.scrollView)
//        addSubview:self.scrollView];
        
        self.chartLineView = LFChartLineView.init(frame: self.scrollView.bounds)
        //initWithFrame:self.scrollView.bounds];
        
        self.chartLineView.yMarkTitles = self.yMarkTitles as NSArray;
        self.chartLineView.xMarkTitles = xMarkTitles as NSArray;
        self.chartLineView.xScaleMarkLEN = self.xScaleMarkLEN;
        self.chartLineView.valueArray = valueArray as! [CGFloat]
        self.chartLineView.maxValue = self.maxValue
        
        self.scrollView.addSubview(self.chartLineView)
        
        var i = 0 //,t = 0
        
        //__block NSUInteger i = 0;
        // 2)遍历下标和元素 采用return 跳出
        for (index,value) in valueArray.enumerated() {
            if ( (value as! String) == "-1") {
                i = index
                return
            }
        }
        
//        for value in valueArray {
//            t = t + 1
//            if value as! String == "-1" {
//                i = t
//                return
//            }
//        }
        
        
//        [valueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj isEqualToString:@"-1"]) {
//            i = idx;
//            *stop = YES;
//            }
//            }];
        if (i > 6) {
            let x = self.xScaleMarkLEN * (CGFloat(i) - 6)
            self.scrollView.contentOffset = CGPoint(x: x, y: 0)
//                CGPointMake(self.xScaleMarkLEN *(i - 6) ,0);
        }
        
        self.chartLineView.mapping()
        
        self.scrollView.contentSize = self.chartLineView.bounds.size;
        
    }
    
    func reloadDatas()  {
         self.chartLineView.reloadDatas()
    }
    

}
