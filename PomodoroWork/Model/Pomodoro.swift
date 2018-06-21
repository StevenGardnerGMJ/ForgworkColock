//
//  Pomodoro.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/9.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import Foundation

// Pomodoro is a singleton object that handles pomodoros and breaks logic
// Pomodoro 文件是一个单例 用于处理 番茄时钟 和 休息间隔逻辑


class Pomodoro {
    
    static let sharedInstance = Pomodoro()
    
    let userDefaults = UserDefaults.standard
    let settings = SettingsManager.sharedManager
    
    var state: State = .default
    
    fileprivate init() {}
    
    var pomodorosCompleted: Int {
        get {
            return userDefaults.integer(forKey: currentDateKey)
        }
        set {
            userDefaults.set(newValue, forKey: currentDateKey)
        }
    }
    
    /// 记录完成数量 每4个做一次判断，能够整除4 长时间休息，否则短时间休息
    func completePomodoro() {
        pomodorosCompleted += 1
        state = (pomodorosCompleted % 4 == 0 ? .longBreak : .shortBreak)
    }
    
    func completeBreak() {
        state = .default
    }
    
    fileprivate var currentDateKey: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
}
