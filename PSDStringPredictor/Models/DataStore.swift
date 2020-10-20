//
//  TargetImageStore.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 14/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import Vision
import AppKit
import SQLite

class DataStore{
    static var stringObjectList: [StringObject] = []
    //DB
    static var dbConnection: Connection!
    static var csvPath: String = ""
    static var fontCsvPath: String = ""
    //ImageProcess
    static var targetNSImage: NSImage  = NSImage.init()
    static var targetImageProcessed: CIImage  = CIImage.init()
    //UI
    static var charFrameIndex = 0
    static var charFrameList: [CharFrame] = []
    static var fontStandardObjectList: [FontStandardObject] = []
    //Image Property
    static var colorMode = -1 // 1 = Light mode, 2 = Dark Mode
    

    static var logListData = [
        LogObject(content: "Log 1", time: "xxx-xxx", category: LogObject.Category.normal),
        LogObject(content: "Log 2", time: "xxx-xxx", category: LogObject.Category.normal)
    ]
    
    static func FillCharFrameList() {
        charFrameList.removeAll()
        for i in 0 ..< stringObjectList.count {
            for j in 0 ..< stringObjectList[i].charRects.count{
                let tmp = CharFrame(rect: stringObjectList[i].charRects[j], char: String(stringObjectList[i].charArray[j]), predictedSize: Int16(stringObjectList[i].charSizeList[j]))
                charFrameList.append(tmp)
            }
        }
    }
    

}

//struct DataStore1{
//    var stringObjectList1: [StringObject] = []
////    @Published var logListData = [
////        LogObject(content: "Log 1", time: "xxx-xxx", category: LogObject.Category.normal),
////        LogObject(content: "Log 2", time: "xxx-xxx", category: LogObject.Category.normal)
////    ]
////    @Published var stringObjectList: [StringObject] = []
////
////    //Image Process
////    @Published var gammaValue: CGFloat = 0.75
//

//}


