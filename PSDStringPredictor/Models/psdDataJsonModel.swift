//
//  psdDataJsonModel.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 26/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

struct JsonObject: Codable{
    var PsdJsonObjectList: [PsdJsonObject]
    var psdStrDict: [Int:[UUID]]
    var relatedDataJsonObject: RelatedDataJsonObject
}

struct RelatedDataJsonObject: Codable{
    var selectedPsdId: Int  //refacting
    var gammaDict: [Int:CGFloat]//refacting
    var expDict: [Int:CGFloat]//refacting
    var DragOffsetDict: [UUID: CGSize]
   
    var selectedStrIDList: [UUID]//refacting
    //Others
    var maskDict: [Int:[charRectObject]]
    var stringIsOn: Bool
//    var psdStrDict:[Int: [UUID]]
}

struct PsdJsonObject: Codable {
    var id: Int
    var stringObjects: [strObjJsonObject]
    var imageURL: URL
    var thumbnail: Data
    var colorMode: String
    var dpi: Int
    var status: String
}

struct strObjJsonObject: Codable{
    var id: UUID
    var content: String
    var tracking: CGFloat
    //var trackingPS: Int16
    var fontSize: CGFloat
    var fontWeight:  String
    var stringRect: CGRect
    var color: [CGFloat]
    var bgColor: [CGFloat]
    var charArray: [String]
    var charRects: [CGRect]
    var charSizeList: [Int16]
//    var charImageList: [Data]
    var charFontWeightList: [String]
    var isPredictedList: [Int]
    //var confidence: CGFloat
    var colorMode: String
    var charColorModeList: [Int]
    var fontName: String
    var alignment: String
    var status: String
    var isParagraph: Bool
//    var colorPixel: Data
    
//    init(){
//        id = UUID()
//        content = ""
//        tracking = 0
//        fontSize = 0
//        fontWeight = ""
//        stringRect = CGRect.init()
//        color = []
//        bgColor = []
//        charArray = []
//        charRects = []
//        charSizeList = []
//        charImageList = []
//        charFontWeightList = []
//        isPredictedList = []
//        colorMode = ""
//        charColorModeList = []
//        fontName = ""
//        alignment = ""
//        status = ""
//        isParagraph = false
//        colorPixel = Data.init()
//    }
}


