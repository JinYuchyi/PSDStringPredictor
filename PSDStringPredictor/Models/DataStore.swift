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
//import SQLite

class DataStore{
    
    static let zeroCIImage = CIImage.init()
    
    static let sizeOfThumbnail = 180

    static var PSPath = ""
    
    static var colorLightModeList: [[CGFloat]] = [
        [0.0, 0.0, 0.0],
        [0.0, 122.0,255.0],
        [52.0, 199.0,89.0],
        [88.0, 86.0, 214.0],
        [255.0, 149.0, 0.0],
        [255.0, 45.0, 85.0],
        [175.0, 82.0, 222.0],
        [255.0, 59.0, 48.0],
        [90.0, 200.0, 250.0],
        [255.0, 204.0, 0.0],
        [142.0, 142.0, 147.0],
        [174.0, 174.0, 178.0],
        [199.0, 199.0, 204.0],
        [209.0, 209.0, 214.0],
        [229.0, 229.0,234.0],
        [ 242.0, 242.0,247.0]

    ]

    static var colorDarkModeList: [[CGFloat]] = [
        [10.0,132.0,255.0],
        [48.0,209.0,88.0],
        [94.0,92.0,230.0],
        [255.0,159.0,10.0],
        [255.0,55.0,95.0],
        [191.0,90.0,242.0],
        [255.0,69.0,58.0],
        [100.0,210.0,255.0],
        [255.0,214.0,10.0],
        [142.0,142.0,147.0],
        [99.0,99.0,102.0],
        [72.0,72.0,74.0],
        [58.0,58.0,60.0],
        [44.0,44.0,46.0],
        [ 28.0,28.0,30.0],
        [ 255.0, 255.0,255.0]
    ]
    
    static var charOffsetInFront: [String: CGFloat] = [:]
    
    static var frontSpaceDict : [String: CGFloat] = [:]
    
//    static var colorLightModeList: [NSColor] = [
//        NSColor.init(red: 0, green: 122, blue: 255, alpha: 255),
//        NSColor.init(red: 52, green: 199, blue: 89, alpha: 255),
//        NSColor.init(red: 88, green: 86, blue: 214, alpha: 255),
//        NSColor.init(red: 255, green: 149, blue: 0, alpha: 255),
//        NSColor.init(red: 255, green: 45, blue: 85, alpha: 255),
//        NSColor.init(red: 175, green: 82, blue: 222, alpha: 255),
//        NSColor.init(red: 255, green: 59, blue: 48, alpha: 255),
//        NSColor.init(red: 90, green: 200, blue: 250, alpha: 255),
//        NSColor.init(red: 255, green: 204, blue: 0, alpha: 255),
//        NSColor.init(red: 142, green: 142, blue: 147, alpha: 255),
//        NSColor.init(red: 174, green: 174, blue: 178, alpha: 255),
//        NSColor.init(red: 199, green: 199, blue: 204, alpha: 255),
//        NSColor.init(red: 209, green: 209, blue: 214, alpha: 255),
//        NSColor.init(red: 229, green: 229, blue: 234, alpha: 255),
//        NSColor.init(red: 242, green: 242, blue: 247, alpha: 255),
//    ]
//    static var colorDarkModeList: [NSColor] = [
//        NSColor.init(red: 10, green: 132, blue: 255, alpha: 255),
//        NSColor.init(red: 48, green: 209, blue: 88, alpha: 255),
//        NSColor.init(red: 94, green: 92, blue: 230, alpha: 255),
//        NSColor.init(red: 255, green: 159, blue: 10, alpha: 255),
//        NSColor.init(red: 255, green: 55, blue: 95, alpha: 255),
//        NSColor.init(red: 191, green: 90, blue: 242, alpha: 255),
//        NSColor.init(red: 255, green: 69, blue: 58, alpha: 255),
//        NSColor.init(red: 100, green: 210, blue: 255, alpha: 255),
//        NSColor.init(red: 255, green: 214, blue: 10, alpha: 255),
//        NSColor.init(red: 142, green: 142, blue: 147, alpha: 255),
//        NSColor.init(red: 99, green: 99, blue: 102, alpha: 255),
//        NSColor.init(red: 72, green: 72, blue: 74, alpha: 255),
//        NSColor.init(red: 58, green: 58, blue: 60, alpha: 255),
//        NSColor.init(red: 44, green: 44, blue: 46, alpha: 255),
//        NSColor.init(red: 28, green: 28, blue: 30, alpha: 255)
//    ]
    
    //Using
    static var wordDict: [String:String] = [
        "icloud": "iCloud",
        "iphone": "IPhone",
        "macbook": "MacBook",
        "Self ie": "Selfie",
        "Outf it": "Outfit"
    ]
    
    //UI
    //static var charFrameIndex = 0
    static var charFrameList: [CharFrame] = []
    static var fontStandardObjectList: [FontStandardObject] = []
    
    
    //Image Property
    static var colorMode = -1 // 1 = Light mode, 2 = Dark Mode
    static var imagePath = ""

//    static var logListData = [
//        LogObject(content: "Log 1", time: "xxx-xxx", category: LogObject.Category.normal),
//        LogObject(content: "Log 2", time: "xxx-xxx", category: LogObject.Category.normal)
//    ]
    
//    static func FillCharFrameList() {
//        charFrameList.removeAll()
//        for i in 0 ..< stringObjectList.count {
//            for j in 0 ..< stringObjectList[i].charRects.count{
//                let tmp = CharFrame(rect: stringObjectList[i].charRects[j], char: String(stringObjectList[i].charArray[j]), predictedSize: (stringObjectList[i].charSizeList[j]))
//                charFrameList.append(tmp)
//            }
//        }
//    }
    
    
    

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


