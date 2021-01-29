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


}
