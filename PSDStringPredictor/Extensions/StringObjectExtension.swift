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
            let tmpObject1 = StringObject.init(id: UUID(), imagePath: self.imagePath, tracking: self.tracking, fontSize: self.fontSize, colorMode: self.colorMode, fontWeight: self.fontWeight, charImageList: Array(self.charImageList[..<index]), color: self.color, bgColor: self.bgColor, charArray: Array(self.charArray[..<index]), charRacts: Array(self.charRects[..<index]), charSizeList: Array(self.charSizeList[..<index]), charFontWeightList: Array(self.charFontWeightList[..<index]), charColorModeList: Array(self.charColorModeList[..<index]), isPredictedList: Array(self.isPredictedList[..<index]), fontName: self.fontName, alignment: self.alignment, status: self.status)
            let tmpObject2 = StringObject.init(id: UUID(), imagePath: self.imagePath, tracking: self.tracking, fontSize: self.fontSize, colorMode: self.colorMode, fontWeight: self.fontWeight, charImageList: Array(self.charImageList[index+1..<count]), color: self.color, bgColor: self.bgColor, charArray: Array(self.charArray[index+1..<count]), charRacts: Array(self.charRects[index+1..<count]), charSizeList: Array(self.charSizeList[index+1..<count]), charFontWeightList: Array(self.charFontWeightList[index+1..<count]), charColorModeList: Array(self.charColorModeList[index+1..<count]), isPredictedList: Array(self.isPredictedList[index+1..<count]), fontName: self.fontName, alignment: self.alignment, status: self.status)
            
//            var tmpObject1 = self
//            tmpObject1.id = UUID()
//            tmpObject1.charImageList = Array(self.charImageList[..<index])
//            tmpObject1.charArray = Array(self.charArray[..<index])
//            tmpObject1.charRects = Array(self.charRects[..<index])
//            tmpObject1.charSizeList = Array(self.charSizeList[..<index])
//            tmpObject1.charFontWeightList = Array(self.charFontWeightList[..<index])
//            tmpObject1.charColorModeList = Array(self.charColorModeList[..<index])
//            tmpObject1.isPredictedList = Array(self.isPredictedList[..<index])
//
//            var tmpObject2 = self
//            tmpObject2.id = UUID()
//            tmpObject2.charImageList = Array(self.charImageList[index+1..<count])
//            tmpObject2.charArray = Array(self.charArray[index+1..<count])
//            tmpObject2.charRects = Array(self.charRects[index+1..<count])
//            tmpObject2.charSizeList = Array(self.charSizeList[index+1..<count])
//            tmpObject2.charFontWeightList = Array(self.charFontWeightList[index+1..<count])
//            tmpObject2.charColorModeList = Array(self.charColorModeList[index+1..<count])
//            tmpObject2.isPredictedList = Array(self.isPredictedList[index+1..<count])
            
            return [tmpObject1, tmpObject2]
        }
    }
    
//    func sliceObject(indexList: [Int]) -> [StringObject] {
//        if indexList.count <= 0 {return [self]}
//        var tmpObject1 = self
//        var strList = [StringObject]()
//        let count = self.charImageList.count
//        var indexCloseList = [-1]
//        indexCloseList = indexCloseList + indexList
//        indexCloseList.append(self.charImageList.count - 1)
//        for (_index, breakPoint) in indexCloseList.enumerated() {
//
////            print(_index)
////            if _index <= 0 || _index >= count - 1 {
////                print("When silcing string object, the index (\(_index)) is out of range.")
////                return nil
////            }else {
//            if (_index + 1 <= indexCloseList.count - 1){
//
//                tmpObject1.id = UUID()
////                print("Slice in index: \(index), on total length \(self.charRects.count)")
//                print("Cut from \(indexCloseList[_index] + 1) to \(indexCloseList[_index + 1])")
//                tmpObject1.charImageList = Array(self.charImageList[(indexCloseList[_index] + 1)..<indexCloseList[_index + 1]])
//                tmpObject1.charArray = Array(self.charArray[(indexCloseList[_index] + 1)..<indexCloseList[_index + 1]])
//                tmpObject1.charRects = Array(self.charRects[(indexCloseList[_index] + 1)..<indexCloseList[_index + 1]])
//                tmpObject1.content =  String(tmpObject1.charArray)
//                tmpObject1.stringRect = CGRect.init(
//                    x: tmpObject1.charRects[0].minX,
//                    y: tmpObject1.charRects[0].minY,
//                    width: (self.charRects[indexCloseList[_index + 1]].maxX - self.charRects[(indexCloseList[_index] + 1)].minX),
//                    height: self.stringRect.height
//                )
//                tmpObject1.charSizeList = Array(self.charSizeList[(indexCloseList[_index] + 1)..<indexCloseList[_index + 1]])
//                tmpObject1.charFontWeightList = Array(self.charFontWeightList[(indexCloseList[_index] + 1)..<indexCloseList[_index + 1]])
//                tmpObject1.charColorModeList = Array(self.charColorModeList[(indexCloseList[_index] + 1)..<indexCloseList[_index + 1]])
//                tmpObject1.isPredictedList = Array(self.isPredictedList[(indexCloseList[_index] + 1)..<indexCloseList[_index + 1]])
//
//                strList.append(tmpObject1)
////                var tmpObject2 = self
////                tmpObject2.id = UUID()
////                tmpObject2.charImageList = Array(self.charImageList[index+1..<count])
////                tmpObject2.charArray = Array(self.charArray[index+1..<count])
////                tmpObject2.charRects = Array(self.charRects[index+1..<count])
////                tmpObject2.stringRect = CGRect.init(
////                    x: self.charRects[index+1].origin.x,
////                    y: self.charRects[index+1].origin.y,
////                    width: (self.charRects[count-1].maxX - self.charRects[index+1].origin.x),
////                    height: self.stringRect.height)
////                tmpObject2.charSizeList = Array(self.charSizeList[index+1..<count])
////                tmpObject2.charFontWeightList = Array(self.charFontWeightList[index+1..<count])
////                tmpObject2.charColorModeList = Array(self.charColorModeList[index+1..<count])
////                tmpObject2.isPredictedList = Array(self.isPredictedList[index+1..<count])
////
////                return [tmpObject1, tmpObject2]
//            }
//        }
//        print("strList count: \(strList.count)")
//        return strList
//    }
    
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

        for index in 1..<(self.charRects.count - 1) {
//            print("char: \(String(self.charArray[index])), index: \(index), dist: \(self.charRects[index+1].minX - self.charRects[index-1].maxX)")
            if index >= 1 && index < self.charRects.count - 1 && self.charArray[index].isWhitespace == true {
                
                if (self.charRects[index+1].minX - self.charRects[index-1].maxX) > maxWidth {
                    //It is gap
//                    print("Gap in \(self.content), index is \(index)")
                    gapIndexList.append(index)
                }
            }
        }
//        print(gapIndexList)
        return gapIndexList
    }
    
    func seprateIfPossible() -> [StringObject]? {
        var result: [StringObject] = []
        let IndexList = self.gapIndexList()
        print("IndexList: \(IndexList)")

        if IndexList.count == 0 {
            return nil
        }else{
            var tmpObject = self
            var preIndex = -1
//            print(IndexList)
            for i in IndexList {
                let _index = i - (preIndex + 1)
                guard let tmpList = tmpObject.sliceObject(index: _index) else {print("Cut string unsuccessfully!");  return nil}
//                print("Seprating '\(self.content)', index is \(i)")
                result.append(tmpList[0])
                print(tmpList[0].content)
                tmpObject = tmpList[1]
                preIndex = i
                
            }
            result.append(tmpObject)
//            print("__count: \(result.count)")
//            for obj in result {
//                print("objs: __ \(obj.content) ")
//
//            }
//            print("result: \(result.map({$0.content}))")
            return result
        }
    }
    
    func toObjectForStringProperty() -> StringObjectForStringProperty {
//        StringObjectForStringProperty.init(content: self.content, posX: (self.stringRect.minX.toString()), posY: (self.stringRect.minY.toString()), fontSize: (self.fontSize.toString()), tracking: String(self.tracking.toString()))
//        StringObjectForStringProperty.init(content: self.content, fontSize: self.fontSize.toString(), tracking: self.tracking.toString(), fontName: self.FontName, color: self.color, stringRect: self.stringRect, alignment: self.alignment)
        StringObjectForStringProperty.init(content: self.content, fontSize: self.fontSize.toString(), tracking: self.tracking.toString(), fontName: self.fontName, color: self.color, stringRect: self.stringRect, alignment: self.alignment, posX: self.stringRect.minX, posY: self.stringRect.minY, width: self.stringRect.width, height: self.stringRect.height)

    }
    
    mutating func setContent(value: String){
        self.content = value
    }
    
    mutating func deleteFontTailLength() {
        let fontOffset = FontUtils.calcFontTailLength(content: self.content, size: self.fontSize)
//        print(fontOffset)
        let newStringRect = CGRect(x: self.stringRect.minX, y: self.stringRect.minY + fontOffset, width: self.stringRect.width, height: self.stringRect.height  )
        self.stringRect = newStringRect
    }
    

    

}
