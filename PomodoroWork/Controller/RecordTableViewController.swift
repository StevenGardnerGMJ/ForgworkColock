//
//  RecordTableViewController.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/6/5.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController,UITextFieldDelegate {
    // 14个
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
    // mark ----------  头部 -----------------
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var BackgroundBtn: UIButton!
    
    @IBOutlet weak var recordTextField: UITextField!
    
    @IBOutlet weak var nametitleLabel: UILabel!
    
    
    let userDefaults = UserDefaults.standard
    
    let arrayKey = ["体重","身高","腰围","臀围","胸围","头围","肩宽","臂长","腿长","心跳","血压","臂展","步长","手指跨度"]
    let arrayValue = ["156斤","171cm","100cm","108cm","106cm","61cm","47cm","172cm","97cm","72次/min","80-120mmHg","172cm","90cm","20cm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        print("沙盒地址：\(libraryPath)")
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        celluserDefauls()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func celluserDefauls() {
        
        if userDefaults.string(forKey: "体重") == nil {
            for t in 0...13 {
                let value = arrayValue[t]
                let key   = arrayKey[t]
                userDefaults.set(value, forKey: key)
            }
        }
        
        
        weightCell.detailTextLabel?.text = userDefaults.string(forKey: "体重")
        heightCell.detailTextLabel?.text = userDefaults.string(forKey: "身高")
        腰围cell.detailTextLabel?.text = userDefaults.string(forKey: "腰围")
        臀围cell.detailTextLabel?.text = userDefaults.string(forKey: "臀围")
        胸围cell.detailTextLabel?.text = userDefaults.string(forKey: "胸围")
        头围cell.detailTextLabel?.text = userDefaults.string(forKey: "头围")
        肩宽cell.detailTextLabel?.text = userDefaults.string(forKey: "肩宽")
        臂长cell.detailTextLabel?.text = userDefaults.string(forKey: "臂长")
        腿长cell.detailTextLabel?.text = userDefaults.string(forKey: "腿长")
        心跳cell.detailTextLabel?.text = userDefaults.string(forKey: "心跳")
        血压cell.detailTextLabel?.text = userDefaults.string(forKey: "血压")
        臂展cell.detailTextLabel?.text = userDefaults.string(forKey: "臂展")
        步长cell.detailTextLabel?.text = userDefaults.string(forKey: "步长")
        手指跨度cell.detailTextLabel?.text = userDefaults.string(forKey: "手指跨度")
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }

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
//        print("textFieldShouldBeginEditing,\(textField.text!),\(record)")
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        record = textField.text! + string
        
//        print(record, range, string)
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let stringN = userDefaults.value(forKey: "\(nametitleLabel.text!)") as! String
//        print("textFieldDidEndEditing")
//        print("textField.text= \(textField.text!),record= \(record)")

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
        userDefaults.synchronize()
        reloadDataCellText(name: nametitleLabel.text!)
        
    }
    
    func reloadDataCellText(name:String) {
        
        celluserDefauls()
        tableView.reloadData()
        //weightCell.textLabel?.text = userDefaults.value(forKey: "体重") as? String
       // heightCell.textLabel?.text = userDefaults.value(forKey: "体重") as? String
//       let detialString = userDefaults.string(forKey: "\(name)")
//        print("r = \(name),userDefalts = \(detialString)")
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "\(name)")
//        cell?.detailTextLabel?.text = detialString
//        print("recordOld = \(recordOld),record = \(record),detailText = \(cell?.detailTextLabel?.text)")
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
    }
    
    
    
    
    
    
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
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(0.01)
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



