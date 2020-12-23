//
//  FileUtils.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

extension String{
    func GetSuffix() -> String{
        let substrs = self.components(separatedBy: ".")
        if(substrs.count > 1){
            return substrs[substrs.count-1]
        }
        else{
            return ""
        }
    }
    
//    func GetFileName() ->String{
//        let substrs = self.components(separatedBy: "/")
//        if(substrs.count > 1){
//            let filename = substrs[substrs.count-1]
//            let name = filename.components(separatedBy: ".")[0]
//            return name
//        }
//        else{
//            return ""
//        }
//    }
    
    func GetFontSizeString() -> String {
        let substrs = self.components(separatedBy: "/")
        if(substrs.count > 1){
            let filename = substrs[substrs.count-1]
            let name = filename.components(separatedBy: ".")[0]
            let fontsize = name.components(separatedBy: "~")[0]
            return fontsize
        }
        else{
            return ""
        }
    }
    
    func GetTrackingString() -> String {
        let substrs = self.components(separatedBy: "/")
        if(substrs.count > 1){
            let filename = substrs[substrs.count-1]
            let name = filename.components(separatedBy: ".")[0]
            let tracking = name.components(separatedBy: "~")[1]
            return tracking
        }
        else{
            return ""
        }
    }
    
    func FixError() ->String {
        if self == "0"{
            return "o"
        }
        
        //大写转小写
        let chStr = String(self)  // 将字符转为字符串
        var num:UInt32 = 0    // 用于接收字符整数值的变量
        for item in chStr.unicodeScalars {
            num = item.value   // 循环只执行一次，获取字符的整数值
        }
        /*
         如果是大小写字母，转换数值
         */
        // 如果是大写字母，转换为小写
        if (num >= 65 && num <= 90) {
            num += 32
            let newChNum = String(UnicodeScalar(num)!)
            return newChNum
        }
        
        return self

        
    }
    
    func isEnglishLowerCase() ->Bool{
        let chStr = String(self)  // 将字符转为字符串
        var num:UInt32 = 0    // 用于接收字符整数值的变量
        for item in chStr.unicodeScalars {
            num = item.value   // 循环只执行一次，获取字符的整数值
        }
        
        if (num >= 97 && num <= 122){
            return true
        }
        return false
    }
    
    
}
