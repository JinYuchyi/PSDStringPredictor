//
//  StringModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI
import CoreImage
import Vision
import Foundation

//struct StringObject: Hashable, Codable, Identifiable {
//    var id: Int
//    var content: String
//    var position: [CGFloat]
//    var width: CGFloat
//    var height: CGFloat
//    var tracking: CGFloat
//    var fontSize: CGFloat
//}

//struct StringObject: Hashable, Codable, Identifiable {
struct StringObject : Identifiable{
    
    var id: UUID = UUID()
    var content: String
    //var position: [CGFloat]
    var tracking: CGFloat
    var fontSize: CGFloat
    var stringRect: CGRect
    var observation : VNRecognizedTextObservation
    var color: Color
    var charArray: [Character]
    var charRects: [CGRect]
    var confidence: CGFloat
    
    //@EnvironmentObject var db: DB
    let ocr: OCR = OCR()
    let fontUtils = FontUtils()
    let db = DB.shared
    //var stringObjectList: [StringObject]
    
    init(){
        //id = UUID()
        content = ""
        //position = []
        tracking = 0
        fontSize = 0
        stringRect = CGRect()
        observation = VNRecognizedTextObservation.init()
        color = Color.black
        charArray = []
        charRects = []
        confidence = 0
        self.color = CalcColor()
    }
    
    init(_ content: String, _ stringRect: CGRect, _ observation: VNRecognizedTextObservation, _ charArray: [Character], _ charRacts: [CGRect], _ confidence: CGFloat){
        self.stringRect = stringRect
        self.content = content
        self.fontSize = 0.0
        //self.position = [0,0]
        self.observation = observation
        self.charArray = charArray
        self.charRects = charRacts
        self.tracking = 10
        self.color = Color.black
        self.confidence = confidence
        //self.color = CalcColor()
        //self.position = CalcPosition()
        self.fontSize = CGFloat(CalcBestWeightForString())
        self.tracking = FetchTrackingFromDB(self.fontSize)
        self.color = CalcColor()
        //self.stringRect = ProcessStringRect(FromRect: stringRect)
        //data.stringObjectIndex = data.stringObjectIndex + 1
        //self.id = (data.stringObjectIndex)

        //FillCharFrameList()

       }
    
    func CalcTracking() -> CGFloat {
        var trackingList: [Double] = []
        for i in 0...charArray.count-2 {
            if (charArray[i].isLowercase && charArray[i+1].isLowercase){
                var dist = abs(charRects[i].minX - charRects[i+1].minX)
                let t = PredictFontTracking(str1: String(charArray[i]), str2: String(charArray[i+1]), fontsize: Double(fontSize), distance: Double(dist))
                print("Tracking of \(String(charArray[i])) and \(String(charArray[i+1])) is \(t), weight is \(fontSize)")

                trackingList.append(t)
            }
        }
        if (trackingList.count > 0){
            var result: CGFloat = 0
            for i in 0...trackingList.count - 1 {
                result += CGFloat(trackingList[i])
            }
            result = result / CGFloat(trackingList.count)
            result = result  / 1000
            print("\(content) tracking is \(result)")
            return result
        }
        else {
            return 0
        }
        
    }
    
    func FetchTrackingFromDB(_ size: CGFloat) -> CGFloat{
        let raw = db.FindTrackingFromTableFont(size: Int64(size))
        return CGFloat(raw)
    }
    
    func CalcColor() -> Color {
        //return Color.white.opacity(1)
        return Color.white.opacity(0.9)
    }
    
    func CalcPosition() -> [CGFloat]{
        if stringRect.isEmpty {
            return [0,0]
        }
        else{
            //return [stringRect.minX, stringRect.minY]
            return [stringRect.minX, stringRect.minY]
        }
    }
    
    mutating func DeleteDescentForRect()  {
        var highLetterEvenHeight: CGFloat = 0
        var lowerLetterEvenHeight: CGFloat = 0
        var fontName: String = ""
        if (fontSize >= 20) {
            fontName = "SFProDisplay-Regular"
        }
        else{
            fontName = "SFProText-Regular"
        }
        
//        let font = fontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize)
//
//        self.position = [self.position[0], self.position[1]  ]
//        stringRect = CGRect(x: stringRect.minX, y: stringRect.minY, width: stringRect.width, height: stringRect.height)
        var n: CGFloat = 0
        var n1: CGFloat = 0
        for (index, c) in charArray.enumerated() {
            if (c.isLowercase && c.isLetter){
                if (
                    c == "p" ||
                    c == "q" ||
                    c == "g" ||
                    c == "y" ||
                    c == "j"
                    ) {
                    highLetterEvenHeight += charRects[index].height
                    n += 1
                }
                else{
                    lowerLetterEvenHeight += charRects[index].height
                    n1 += 1
                }
            }
        }
        
        //Calc the descent value
        var descent: CGFloat = 0
        if (n != 0){
            highLetterEvenHeight = highLetterEvenHeight / n
        }
        if (n1 != 0){
            lowerLetterEvenHeight = lowerLetterEvenHeight / n1
        }
        if (highLetterEvenHeight == 0){
            descent = 0
        }
        else{
            descent = highLetterEvenHeight - lowerLetterEvenHeight
        }

        stringRect = CGRect(x: stringRect.origin.x, y: stringRect.origin.y + descent, width: stringRect.width, height: stringRect.height - descent)
        

    }
    
    func CalcWeightForSingleChar(_ char: String, _ width: Int64, _ height: Int64) -> Int64{
        //var objArray: [Row] = []
        var result: Int64 = 0
        
//        if(db == nil){
//            print("DB equals null.")
//            return 0
//        }
        
        let objList = DB.QueryFor(dbConnection: DataStore.dbConnection, char: char, width: width, height: height)

        
        func Predict() -> Int64 {
            Int64(PredictFontSize(character: char, width: Double(width), height: Double(height)))
        }

        func FindIt() -> Int64{
            let strObj = objList[0][TABLE_CHARACTER_WIGHT]
            result = strObj
            return strObj
        }
        
        return result == 0 ? Predict() : FindIt()

    }
    
    func CalcBestWeightForString()-> Float{

        var weightArray:[Int64] = []
        //Find weight for each character, and guess the best choice for the string's weight
        for (index, char) in self.charArray.enumerated(){
            if char.isNumber || char.isLetter{
                var tempweight = CalcWeightForSingleChar(String(char), Int64(charRects[index].width), Int64(charRects[index].height))
                //print("find:\(String(char)), \(Int64(charRects[index].width)), \(Int64(charRects[index].height)). weight:\(tempweight)")
                if (tempweight != 0){
                    weightArray.append(tempweight)
                }
            }
        }
        //return FindBestWeightFromWeightArray(FromArray: weightArray)
        var rawSizeNum = FindBestWeightFromWeightArray(FromArray: weightArray)
        var all = Array(try! DataStore.dbConnection.prepare(TABLE_CHARACTER))
        var result = all.FindNearest(toNumber: Int(rawSizeNum.rounded()) )
        
        return Float(result)
    }
    
    private func FindBestWeightFromWeightArray(FromArray weightArray: [Int64]) -> Float{
        var weightDict: [Int64: Int64] = [:]
        for w in weightArray{
            let keyExists = weightDict[w] != nil
            if keyExists == false { //If the weight is new
                weightDict[w] = 1
            }
            else{
                let index = weightDict[w]
                weightDict[w] = index! + 1
            }
        }
        let sortedValue = weightDict.values.sorted(by: >)
        //let filtered = sortedValue.filter { $0.value ==  sortedValue[0]} //Return the first key from sorted Dict
        let filtered = weightDict.filter { $0.1 ==  sortedValue[0] }
        var result: Float = 0.0
        for (key, value) in filtered{
            result = result + Float(key)
        }
        result = result / Float(filtered.count)
        //print("result:\(result)")
        return result
    }
    
//    func Count() -> Int{
//        return stringObjectList.count
//    }
    
//    mutating func AddElement(NewElement element: StringObject){
//        stringObjectList.append(element)
//    }
    
//    func Clean(){
//        data.stringObjectList.removeAll()
//    }
    
    func PredictStringObjects(FromCIImage img: CIImage){
        //data.targetImageSize = [Int64(img.extent.width), Int64(img.extent.height)]

        if img.extent.width > 0{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: img )
            DataStore.stringObjectList = stringObjects
        }
        else{
            print("Load Image failed.")
        }
    }
    
//    func GetStringObjectFromID(stringObjectId id: Int) -> StringObject{
//        data.stringObjectList
//    }
    
 

}


