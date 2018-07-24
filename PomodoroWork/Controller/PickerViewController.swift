//
//  PickerViewController.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/10.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit


protocol PickerViewControllerDelegate: class {
    func pickerDidFinishPicking(_ picker: PickerViewController)
}

class PickerViewController: UITableViewController {
    var options: [Int]!
    var specifier = "minutes"
    
    var type: PickerType!
    var selectedValue: Int!
    var selectedIndexPath: IndexPath?
    var delegate: PickerViewControllerDelegate?
    
    fileprivate struct PickerOptions {
        //计时器 短时休憩 长时间休憩 番茄任务数
        static let pomodoroLength = [1,5,15,25, 30, 35, 45,60,90].map { $0 * 60 }
        static let shortBreakLength = [1,3, 5, 9, 11].map { $0 * 60 }
        static let longBreakLength = [10, 15, 20, 25, 30].map { $0 * 60 }
        static let targetPomodoros = (2...20).map { $0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type! {
        case .pomodoroLength:
            options = PickerOptions.pomodoroLength
        case .shortBreakLength:
            options = PickerOptions.shortBreakLength
        case .longBreakLength:
            options = PickerOptions.longBreakLength
        case .targetPomodoros:
            options = PickerOptions.targetPomodoros
        }
        // 选择第几个
        if let index = options.index(of: selectedValue), type != .targetPomodoros {
            selectedIndexPath = IndexPath(row: index, section: 0)
        }

    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath)
        
        // Configure the cell...
        let value = options[indexPath.row]
        //判断 类型是否是 时钟个数 是保持原值 否除60
        let formattedValue = (type == PickerType.targetPomodoros ? value : value / 60)
        cell.textLabel?.text = "\(formattedValue) \(specifier)"

        let currentValue = options[indexPath.row]
        if currentValue == selectedValue {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 如果 新值 和 选中相等 ——>返回
        if options[indexPath.row] == selectedValue {
            return
        }
        // 放 √ 在先前的cell 上
        if let newCell = tableView.cellForRow(at: indexPath) {
            newCell.accessoryType = .checkmark
        }
        //  移除 √  除先前cell上的
        if let previousIndexPath = selectedIndexPath,
            let oldCell = tableView.cellForRow(at: previousIndexPath) {
            oldCell.accessoryType = .none
        }
        
        selectedIndexPath = indexPath
        selectedValue = options[indexPath.row]
        updateSettings()

    }
    
    // Navigating back
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParentViewController {
            delegate?.pickerDidFinishPicking(self)
        }
    }
    
    fileprivate func updateSettings() {
        let settings = SettingsManager.sharedManager
        
        switch type! {
        case .pomodoroLength:
            settings.pomodoroLength = selectedValue
        case .shortBreakLength:
            settings.shortBreakLength = selectedValue
        case .longBreakLength:
            settings.longBreakLength = selectedValue
        case .targetPomodoros:
            settings.targetPomodoros = selectedValue
        }
    }
    
}








