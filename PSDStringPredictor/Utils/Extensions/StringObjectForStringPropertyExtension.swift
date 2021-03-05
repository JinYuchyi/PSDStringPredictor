//
//  StringObjectForStringPropertyExtension.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 17/2/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

extension StringObjectForStringProperty {
    func toStringObject(strObj: StringObject) -> StringObject{
        var tempObj = strObj
//        let tmpRect = CGRect.init(x: self.posX.toCGFloat(), y: self.posY.toCGFloat(), width: tempObj.stringRect.width, height: tempObj.stringRect.height)
        let tmpRect = CGRect.init(x: self.posX.toCGFloat(), y: self.posY.toCGFloat(), width: self.width, height: self.height)
        tempObj.stringRect = tmpRect
        tempObj.content = self.content
        tempObj.tracking = self.tracking.toCGFloat()
        tempObj.fontSize = self.fontSize.toCGFloat()
        tempObj.FontName = self.fontName
//        tempObj.color = self.color
        return tempObj
    }
}
