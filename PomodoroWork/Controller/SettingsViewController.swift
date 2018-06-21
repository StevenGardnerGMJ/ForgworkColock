//
//  SettingsViewController.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/9.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class SettingsViewController: UITableViewController, PickerViewControllerDelegate,MFMailComposeViewControllerDelegate{
   

    // 设置 section
    @IBOutlet weak var pomodoroLengthLabel: UILabel!
    @IBOutlet weak var shortBreakLengthLabel: UILabel!
    @IBOutlet weak var longBreakLengthLabel: UILabel!
    @IBOutlet weak var targetPomodorosLabel: UILabel!
    
    // 关于 section
    @IBOutlet weak var tContactCell: UITableViewCell!
    @IBOutlet weak var homepageCell: UITableViewCell!
    @IBOutlet weak var appStoreCell: UITableViewCell!
    @IBOutlet weak var versionCell: UITableViewCell!
    
    fileprivate let userDefaults = UserDefaults.standard
    fileprivate let settings = SettingsManager.sharedManager
    
    fileprivate struct About {
        static let eMailURL = "wawasummer@126.com"
        static let appStoreURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1378004614&pageNumber=0&sortOrdering=2&mt=8"
        static let homepageURL = "  E-mali: wawasummer@126.com \n 电话: 157-1886-7368  \n QQ:525884052！"
        static let homepageTitle = "广告合作"
        static let versionURL = "版本1.1"
        static let versionURL2 = "简介：<工作计时>将大任务分成小目标，专注工作，逐步完成。\n每完成一个是短时休憩，\n每进行4个时段后为<长时间休息>。"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    
    fileprivate func setupLabels() {
        pomodoroLengthLabel.text = "\(settings.pomodoroLength / 60) minutes"
        shortBreakLengthLabel.text = "\(settings.shortBreakLength / 60) minutes"
        longBreakLengthLabel.text = "\(settings.longBreakLength / 60) minutes"
        targetPomodorosLabel.text = "\(settings.targetPomodoros) 个"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let picker = segue.destination as? PickerViewController {
            
            switch segue.identifier! {
            case "工作计时":
                picker.selectedValue = settings.pomodoroLength
                picker.type = PickerType.pomodoroLength
            case "休息计时":
                picker.selectedValue = settings.shortBreakLength
                picker.type = PickerType.shortBreakLength
            case "长时间休息":
                picker.selectedValue = settings.longBreakLength
                picker.type = PickerType.longBreakLength
            case "任务目标数":
                picker.specifier = "个"
                picker.selectedValue = settings.targetPomodoros
                picker.type = PickerType.targetPomodoros
            default:
                break
            }
            picker.delegate = self
        }
    }

    func pickerDidFinishPicking(_ picker: PickerViewController) {
        setupLabels()
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)!
        switch cell {
        case tContactCell: jumpEmail(About.eMailURL)
        case homepageCell: jumpAlert(About.homepageURL, About.homepageTitle)
        case appStoreCell: openURL(About.appStoreURL)
        case versionCell : jumpAlert(About.versionURL2, About.versionURL)
        default: return
        }
    }
    
    // MARK: -  打开URL
    fileprivate func openURL(_ url: String) {
        let application = UIApplication.shared
        
        if let url = URL(string: url) {
//            application.openURL(url)
            if #available(iOS 10.0, *) {
                application.open(url, options:[:] , completionHandler: nil)
            } else {
                // Fallback on earlier versions
                application.openURL(url)
            }
        }
    }
    // 广告合作
    fileprivate func jumpAlert(_ word:String,_ title:String) {
        let alertVC = UIAlertController(title: title, message: word, preferredStyle: .alert)
        let sure = UIAlertAction(title: "确定", style: .destructive, handler: nil)
        alertVC.addAction(sure)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /* 意见反馈 */
    fileprivate func jumpEmail(_ url:String) {
        print("意见反馈")
        if MFMailComposeViewController.canSendMail() {
            let mailVC = mailFeedBack(url)
            self.present(mailVC, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()//无邮箱账户容错处理
        }
    }
    
    func mailFeedBack(_ url:String) -> MFMailComposeViewController{
        
        // 获取设备名称
        let deviceName = UIDevice.current.name
        // 获取系统版本号
        let systemVersion = UIDevice.current.systemVersion
        // 获取设备的型号
        let modelName = UIDevice.current.modelName
        // 获取设备唯一标识符
        //        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
        
        
        // 调用
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["< \(url) >"])
        mailComposeVC.setSubject("邮件主题:建议与意见")
        mailComposeVC.setMessageBody("反馈的内容:\n\n\n\n\n 设备名称:\(deviceName)\n 系统版本：\(systemVersion)\n 设备型号：\(modelName)", isHTML: false)
        return mailComposeVC
    }
    // 对邮箱容错处理
    func showSendMailErrorAlert(){
        let mailErrorAlert = UIAlertController(title: "无法发送", message: "陛下您的手机邮箱没有设置账户", preferredStyle: UIAlertControllerStyle.alert)
        mailErrorAlert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { _ in }))
        self.present(mailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.sent.rawValue:
            print("发送成功")
        case MFMailComposeResult.cancelled.rawValue:
            print("发送失败")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
//appStore跳转评分方法 http://www.cocoachina.com/ios/20170802/20095.html
}






