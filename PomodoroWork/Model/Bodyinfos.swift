//
//  Bodyinfos.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/6/26.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class Bodyinfos {
    static let shareInstance = Bodyinfos()
    fileprivate init() {}
    
    let userDefaults = UserDefaults.standard
    // 用于存储用户输入数据
    // key: 体重，血压。。。
    // value: 152.5斤
    // date: 日期 array
    // change:改变值 dic
    // userDafults  key 为日期， value 为数据Array

}
