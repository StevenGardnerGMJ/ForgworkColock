//
//  RecordTableViewController.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/6/5.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var weightCell: UITableViewCell!
    @IBOutlet weak var heightCell: UITableViewCell!
    
    @IBOutlet weak var 腰围cell: UITableViewCell!
    
    @IBOutlet weak var 臀围cell: UITableViewCell!
    
    @IBOutlet weak var 胸围cell: UITableViewCell!
    
    @IBOutlet weak var 头围cell: UITableViewCell!
    @IBOutlet weak var 肩宽cell: UITableViewCell!
    
    @IBOutlet weak var 臂长cell: UITableViewCell!
    @IBOutlet weak var 腿长cell: UITableViewCell!
    
    @IBOutlet weak var 心跳cell: UITableViewCell!
    
    @IBOutlet weak var 血压cell: UITableViewCell!
    
    @IBOutlet weak var 臂展cell: UITableViewCell!
    
    @IBOutlet weak var 步长cell: UITableViewCell!
    
    @IBOutlet weak var 手指跨度cell: UITableViewCell!
    // mark ----  头部 -------
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var BackgroundBtn: UIButton!
    
    @IBOutlet weak var recordTextField: UITextField!
    
    @IBOutlet weak var nametitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 避免字符串差值为可选值
        let cell = tableView.cellForRow(at: indexPath)!
        nametitleLabel.text = cell.textLabel?.text
        
        switch cell {
        case weightCell:
             recordTextField.text = (cell.detailTextLabel?.text)!
        case 心跳cell:
             recordTextField.text = (cell.detailTextLabel?.text)!
        case 血压cell:
            recordTextField.text = (cell.detailTextLabel?.text)!
        default:
            recordTextField.text = (cell.detailTextLabel?.text)!
        }
        
    }
    
    
    var record:String!
    var recordOld:String!
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        popAnimation()
        record = textField.text!
        recordOld = textField.text!
        textField.text = ""
        print("textFieldShouldBeginEditing,\(textField.text),\(record)")
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        record = textField.text! + string
        
        print(record, range, string)
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let stringN = userDefaults.value(forKey: "\(nametitleLabel.text!)") as! String
        print("textFieldDidEndEditing")
        print("textField.text= \(textField.text),record= \(record),stringN = \(stringN)")

        if (recordOld == record) {
            print("数据相同")
            textField.text = record
            return
        } else {
            recordOld = record
        }
        
        switch nametitleLabel.text! {
        case "体重":
            textField.text = record + "斤"
            userDefaults.set(textField.text, forKey: "体重")
        case "血压":
            textField.text = record + "mmHg"
            userDefaults.set(textField.text, forKey: "血压")
        case "心跳":
            textField.text = record + "次/min"
            userDefaults.set(textField.text, forKey: "心跳")
        default:
            textField.text = record + "cm"
            userDefaults.set(textField.text, forKey: "\(nametitleLabel.text!)")
        }
        
    }
    
    
    
    
    
    fileprivate let userDefaults = UserDefaults.standard
    // swift 监测是否使用三方键盘 if 禁用Xbutton键盘
    
    /// 添加动画效果
    func popAnimation(){
        let force:CGFloat = 1
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.scale"
        animation.values = [0, 0.2*force, -0.2*force, 0.2*force, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = CFTimeInterval(1.0)
        animation.isAdditive = true
        animation.repeatCount = 2
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(0.8)
        BackgroundBtn.layer.add(animation, forKey: "pop")
        recordTextField.layer.add(animation, forKey: "pop")
    }
    
    
    public class func springEaseInOut(duration: TimeInterval, animations: (() -> Void)!) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                animations()
        }, completion: nil
        )
    }
    
       
    
    

}



