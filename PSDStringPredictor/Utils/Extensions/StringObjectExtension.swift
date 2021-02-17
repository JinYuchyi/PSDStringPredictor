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
            print("When silcing string object, the index (/(index)) is out of range.")
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
        var maxWidth: CGFloat = 0
        for index in 0..<charArray.count {
            if charArray[index].isNumber || charArray[index].isLetter {
                if charRects[index].width > maxWidth {
                    maxWidth = charRects[index].width
                }
            }
        }

        for index in 0..<self.charRects.count {
            if index >= 1 && index < self.charRects.count - 1 && self.charArray[index] == " " {
                if (self.charRects[index+1].minX - self.charRects[index-1].maxX) > maxWidth {
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
//        print("IndexList count: \(IndexList.count)")

        if IndexList.count == 0 {
            return nil
        }else{
            var tmpObject = self
            var preIndex = -1
            print(IndexList)
            for i in IndexList {
                let _index = i - (preIndex + 1)
                guard let tmpList = tmpObject.sliceObject(index: _index) else {print("Slide object unsuccess!");  return nil}
                print("Seprating '\(self.content)', index is \(i)")
                result.append(tmpList[0])
                tmpObject = tmpList[1]
                preIndex = i
                
            }
            result.append(tmpObject)
//            print("__count: \(result.count)")
//            for obj in result {
//                print("objs: __ \(obj.content) ")
//
//            }
            print("seprate number: \(result.count)")
            return result
        }
    }
    
    func toObjectForStringProperty() -> StringObjectForStringProperty {
        StringObjectForStringProperty.init(content: self.content, posX: (self.stringRect.minX.toString()), posY: (self.stringRect.minY.toString()), fontSize: (self.fontSize.toString()), trakcing: String(self.tracking.toString()))
    }
}
