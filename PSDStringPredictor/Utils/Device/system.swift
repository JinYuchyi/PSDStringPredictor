//
//  system.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 6/3/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import Cocoa

class softwareInfo {
    static func getMainVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion :AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as AnyObject
        return majorVersion as! String
    }
}
