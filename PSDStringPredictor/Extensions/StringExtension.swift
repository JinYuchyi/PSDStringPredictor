//
//  StringExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 28/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

extension String{
    
    func getAttributedString<T>(_ key: NSAttributedString.Key, value: T) -> NSAttributedString {
       let applyAttribute = [ key: T.self ]
       let attrString = NSAttributedString(string: self, attributes: applyAttribute)
       return attrString
    }
    
    var isNumeric : Bool {
            return Double(self) != nil
        }
    
    func toCGFloat() -> CGFloat {
        var result: CGFloat = 0.0
        if let n = NumberFormatter().number(from: self) {
            result = CGFloat.init(n)
        }
        return result
    }
    
    func find(pattern: String) -> NSTextCheckingResult? {
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            return re.firstMatch(
                in: self,
                options: [],
                range: NSMakeRange(0, self.utf16.count))
        } catch {
            return nil
        }
    }

    func replace(pattern: String, template: String) -> String {
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            return re.stringByReplacingMatches(
                in: self,
                options: [],
                range: NSMakeRange(0, self.utf16.count),
                withTemplate: template)
        } catch {
            return self
        }
    }
    
    func findZeroBehindNumberIndex() -> [Int] {
        var result: [Int] = []
        let cList = Array(self)
        for i in 0..<cList.count {
            if cList[i] == "0" && i > 0 && cList[i-1].isNumber  {
                result.append(i)
            }
        }
        return result
    }
    
    func findDots() -> [Int]{
        var result: [Int] = []
        let cList = Array(self)
        for i in 0..<cList.count {
            
            if cList[i] == "." {
                result.append(i)
            }

        }
        return result
    }


}
