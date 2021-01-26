//
//  ArrayExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage

//protocol P {}
//extension Int: P {}
extension Array  {

    func MajorityElement<T: Hashable>() -> (T) {
        var dict: [T:Int] = [:]
        var result: T!
        for ele in self {
            if dict[ele as! T] == nil {
                dict[ele as! T] = 0

            }else{
                dict[ele as! T]! += 1

            }
        }
        var max = -1
        for (key, value) in dict {
            if value > max {
                max = value
                result = key
            }
        }
        return result
    }
    
}

extension Array where Element == StringObject {
    func LastValidItem()-> StringObject {
        if self.count > 0 {
            return self.last!
        }else{
            let obj = StringObject()
            return obj
        }
    }
    
    func FindByID(_ id: UUID) -> StringObject? {
        return self.first(where: {$0.id == id})
    }
    
    func ContainsSame(_ obj: StringObject) -> Bool {
        for item in self{
            if item.stringRect.intersects(obj.stringRect){
                return true
            }
        }
        return false
    }
}

extension Array where Element == Character {
    func ToStringArray()-> [String] {
        var result: [String] = []
        for c in self{
            result.append(String(c))
        }
        return result
    }
}

extension Array where Element == Data {
    func toCIImageList()-> [CIImage] {
        var result: [CIImage] = []
        for c in self{
            if c.isEmpty == false{
                result.append(CIImage.init(data: c)!)
            }else{
                result.append(CIImage.init())
            }
        }
        return result
    }
}

extension Array where Element == CGFloat {
    func toCGColor()-> CGColor {
        return CGColor.init(srgbRed: self[0], green: self[1], blue: self[2], alpha: self[3])
    }
}
