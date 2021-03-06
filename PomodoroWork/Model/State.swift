//
//  State.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/9.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import Foundation
import UIKit

enum State {
    case `default`, shortBreak, longBreak
}

/// 获取设备型号
public extension UIDevice {
    var modelName:String {
        var systenInfo = utsname()//【uname系统调用】功能描述:获取当前内核名称和其它信息。
        uname(&systenInfo)
        let machineMirror = Mirror(reflecting: systenInfo.machine)
        let identifier = machineMirror.children.reduce(""){ identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        // iPhone
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1","iPhone9,3":                   return "iPhone 7"
        case "iPhone9,2","iPhone9,4":                   return "iPhone 7 plus"
        case "iPhone10,3","iPhone10,6":                 return "iPhone X"
        case "iPhone10,1","iPhone10,4":                 return "iPhone 8"
        case "iPhone10,2","iPhone10,5":                 return "iPhone 8 Plus"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4","iPhone11,6":                 return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        // iPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5"
        case "AppleTV5,3":                              return "Apple TV"
        // Apple Watch
        case "Watch1,1" : return"Apple Watch"
        case "Watch1,2" : return"Apple Watch"
        case "Watch2,6" : return"Apple Watch Series 1"
        case "Watch2,7" : return"Apple Watch Series 1"
        case "Watch2,3" : return"Apple Watch Series 2"
        case "Watch2,4" : return"Apple Watch Series 2"
        case "Watch3,1" : return"Apple Watch Series 3"
        case "Watch3,2" : return"Apple Watch Series 3"
        case "Watch3,3" : return"Apple Watch Series 3"
        case "Watch3,4" : return"Apple Watch Series 3"
        case "Watch4,1" : return"Apple Watch Series 4"
        case "Watch4,2" : return"Apple Watch Series 4"
        case "Watch4,3" : return"Apple Watch Series 4"
        case "Watch4,4" : return"Apple Watch Series 4"
            
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}





