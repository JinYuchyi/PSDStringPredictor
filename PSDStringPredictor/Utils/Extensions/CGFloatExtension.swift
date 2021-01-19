//
//  CGFloatExtension.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 19/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

extension CGFloat {
    func keepDecimalPlaces(num: Int)-> CGFloat{
        if num == 1 {
            return (self * 10).rounded() / 10
        } else if num == 2 {
            return (self * 100).rounded() / 100
        }else if num == 3 {
            return (self * 1000).rounded() / 1000
        }else{
            return self

        }
    }
}
