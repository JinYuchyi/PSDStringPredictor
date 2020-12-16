//
//  ArrayExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

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
}
