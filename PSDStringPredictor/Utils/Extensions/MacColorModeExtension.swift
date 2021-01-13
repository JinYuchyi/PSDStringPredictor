//
//  MacColorModeExtension.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 13/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

extension MacColorMode {
    func toString() -> String{
        if self == .dark {
            return "Dark"
        }else {
            return "Light"
        }
    }
}
