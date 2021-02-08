//
//  StringObjectExtension.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 7/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import CoreImage

extension StringObject{

    func sliceObject(index: Int) -> [StringObject]? {
//        var strList = [StringObject]()
        let count = self.charImageList.count

        if index <= 0 || index >= count - 1 {
            return nil
        }else {
            let tmpObject1 = StringObject.init(id: UUID(),tracking: self.tracking, fontSize: self.fontSize, colorMode: self.colorMode, fontWeight: self.fontWeight, charImageList: Array(self.charImageList[..<index]), color: self.color, bgColor: self.bgColor, charArray: Array(self.charArray[..<index]), charRacts: Array(self.charRects[..<index]), charSizeList: Array(self.charSizeList[..<index]), charFontWeightList: Array(self.charFontWeightList[..<index]), charColorModeList: Array(self.charColorModeList[..<index]), isPredictedList: Array(self.isPredictedList[..<index]), fontName: self.FontName, alignment: self.alignment, status: self.status)
            let tmpObject2 = StringObject.init(id: UUID(),tracking: self.tracking, fontSize: self.fontSize, colorMode: self.colorMode, fontWeight: self.fontWeight, charImageList: Array(self.charImageList[index+1..<count]), color: self.color, bgColor: self.bgColor, charArray: Array(self.charArray[index+1..<count]), charRacts: Array(self.charRects[index+1..<count]), charSizeList: Array(self.charSizeList[index+1..<count]), charFontWeightList: Array(self.charFontWeightList[index+1..<count]), charColorModeList: Array(self.charColorModeList[index+1..<count]), isPredictedList: Array(self.isPredictedList[index+1..<count]), fontName: self.FontName, alignment: self.alignment, status: self.status)
            return [tmpObject1, tmpObject2]
        }
    }
    
    func gapIndexList() -> [Int] {
        var gapIndexList: [Int] = []
        if self.charRects.count <= 2 {
            return []
        }
//        let cArray = self.charArray.map({$0 != " "})
//        let maxWidth = self.charRects.map({$0.width}).max()!
        for index in 0..<self.charRects.count {
            if index >= 1 && index < self.charRects.count - 1 && self.charArray[index] == " " {
                if (self.charRects[index+1].minX - self.charRects[index-1].maxX) > self.charRects[index-1].width {
                    //It is gap
                    print("Gap in \(self.content), index is \(index)")
                    gapIndexList.append(index)
                }
            }
        }
        return gapIndexList
    }
    
    func seprateIfPossible() -> [StringObject]? {
        
        var result: [StringObject] = []
        let IndexList = self.gapIndexList()
        if IndexList.count == 0 {
            return nil
        }else{
            var tmpObject = self
            for i in IndexList {
                
                guard let tmpList = tmpObject.sliceObject(index: i) else {  return nil}
                print("Seprating '\(self.content)', index is \(i)")
                result.append(tmpList[0])
                tmpObject = tmpList[1]
                
            }
            result.append(tmpObject)
            print("__count: \(result.count)")
            for obj in result {
                print("objs: __ \(obj.content) ")

            }
            
            return result
        }
    }
}
