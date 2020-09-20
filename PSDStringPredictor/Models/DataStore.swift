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

var stringObjectList: [StringObject] = []
//DB
var dbConnection: Connection!
//ImageProcess
var targetNSImage: NSImage  = NSImage.init()
var targetImage: CIImage  = CIImage.init()
var targetImageProcessed: CIImage  = CIImage.init()
var targetImageName: String = "default_image"
//UI
var charFrameIndex = 0
var charFrameList: [CharFrame] = []

var logListData = [
    LogObject(content: "Log 1", time: "xxx-xxx", category: LogObject.Category.normal),
    LogObject(content: "Log 2", time: "xxx-xxx", category: LogObject.Category.normal)
]

struct DataStore{

//    @Published var logListData = [
//        LogObject(content: "Log 1", time: "xxx-xxx", category: LogObject.Category.normal),
//        LogObject(content: "Log 2", time: "xxx-xxx", category: LogObject.Category.normal)
//    ]
//    @Published var stringObjectList: [StringObject] = []
//
//    //Image Process
//    @Published var gammaValue: CGFloat = 0.75

    func FillCharFrameList() {
        charFrameList.removeAll()
        for i in 0 ..< stringObjectList.count {
            for j in 0 ..< stringObjectList[i].charRects.count{
                let tmp = CharFrame(rect: stringObjectList[i].charRects[j], char: String(stringObjectList[i].charArray[j]))
                charFrameList.append(tmp)
            }
        }
    }
}


