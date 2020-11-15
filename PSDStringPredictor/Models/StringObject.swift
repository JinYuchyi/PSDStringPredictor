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
    var fontWeight:  Font.Weight
    var stringRect: CGRect
    var observation : VNRecognizedTextObservation
    var color: Color
    var charArray: [Character]
    var charRects: [CGRect]
    var charSizeList: [CGFloat]
    var charImageList: [CIImage]
    var charFontWeightList: [Font.Weight]
    var isPredictedList: [Int]
    
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
        fontWeight =  Font.Weight.regular
        charImageList = []
        stringRect = CGRect()
        observation = VNRecognizedTextObservation.init()
        color = Color.black
        charArray = []
        charRects = []
        charSizeList = []
        charFontWeightList = []
        confidence = 0
        isPredictedList = []
        self.color = CalcColor()
        self.fontWeight = PredictFontWeight()
    }
    
    init(_ content: String, _ stringRect: CGRect, _ observation: VNRecognizedTextObservation, _ charArray: [Character], _ charRacts: [CGRect], charImageList: [CIImage], _ confidence: CGFloat){
        self.stringRect = stringRect
        self.content = content
        self.fontSize = 0.0
        self.fontWeight = Font.Weight.regular
        //self.position = [0,0]
        self.observation = observation
        self.charArray = charArray
        self.charRects = charRacts
        self.charSizeList = []
        self.charImageList = charImageList
        self.charFontWeightList = []
        self.tracking = 10
        self.color = Color.black
        self.confidence = confidence
        self.isPredictedList = []
        //self.color = CalcColor()
        //self.position = CalcPosition()
        self.fontWeight = PredictFontWeight()
        let sizeFunc = CalcBestSizeForString()
        self.fontSize = CGFloat(sizeFunc.0)
        self.tracking = FetchTrackingFromDB(self.fontSize)
        self.color = CalcColor()
        self.charSizeList = sizeFunc.1
        self.isPredictedList = sizeFunc.2
        
    }


    
    func FetchTrackingFromDB(_ size: CGFloat) -> CGFloat{
        
        let item = TrackingDataManager.FetchNearestOne(AppDelegate().persistentContainer.viewContext, fontSize: Int16(size.rounded()))
        //return CGFloat(item.fontTracking)/1000
        //print("item.fontTrackingPoints ",item.fontTrackingPoints)
        //return CGFloat(item.fontTrackingPoints)
        return CGFloat(item.fontTrackingPoints)
    }
    
    func PredictTracking()->Double{
        var trackings: [Double] = []
        for index in 0..<charArray.count{
            if (index + 1 < charArray.count && charArray[index].isLetter && charArray[index+1].isLetter){
                let strs: String = String(charArray[index]) + String(charArray[index+1])
                let _width = fabs(charRects[index].minX - charRects[index+1].maxX) / fontSize * 12
                let _fontWeight = "SFProText-Regular"
                let tmp = PredictFontTracking(str: strs, fontSize: Double(fontSize), width: Double(_width), fontWeight: _fontWeight)
                print("Predicting \(strs) - fontsize: \(fontSize) - width: \(_width) - result: \(tmp) ")
                trackings.append(tmp)
            }
        }
        let result: Double = trackings.MajorityElement()
        print("Predict tracking: \(result)")
        return result
    }
    
    func CalcColor() -> Color {
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
        
        //Condition of if has p,q,g,y,j character in string,
        //We have to adjust string position and size
        var n: CGFloat = 0
        var n1: CGFloat = 0
        var hasLongTail = false
        for (index, c) in charArray.enumerated() {
            //if (c.isLowercase && c.isLetter){
            if (
                c == "p" ||
                    c == "q" ||
                    c == "g" ||
                    c == "y" ||
                    c == "j" ||
                    c == "," ||
                    c == ";"
            ) {

                hasLongTail = true
            }

        }

        var descent: CGFloat = 0
        if hasLongTail == true{
            descent = FontUtils.GetFontInfo(Font: "SF Pro Text", Content: content, Size: fontSize).descent
        }
        
        
        stringRect = CGRect(x: stringRect.origin.x, y: stringRect.origin.y + descent, width: stringRect.width, height: stringRect.height - descent)
        
        
    }
    
    func CalcSizeForSingleChar(_ char: String, _ width: Int16, _ height: Int16, _ fontWeight: String) -> (Int16, Int){
        var isPredicted = 0
        var result: Int16 = 0
        
        var keyvalues: [String: AnyObject] = [:]
        keyvalues["char"] = char as AnyObject
        //keyvalues["fontSize"] = fontSize as AnyObject
        keyvalues["width"] = width as AnyObject
        keyvalues["height"] = height as AnyObject
        keyvalues["fontWeight"] = fontWeight as AnyObject
        //keyvalues["fontWeight"] = fontWeight as AnyObject
        let objList = CharDataManager.FetchItems(AppDelegate().persistentContainer.viewContext, keyValues: keyvalues)
        
        if (objList.count == 0){
            isPredicted = 1
            print("\(char), with width \((width)) - height \((height)) - weight \(fontWeight). Pridict it as \(PredictFontSize(character: char, width: (width), height: (height), fontWeight: fontWeight))")
            return (Int16(PredictFontSize(character: char, width: (width), height: (height), fontWeight: fontWeight).rounded()), isPredicted)
        }else{
            isPredicted = -1
            print("\(char), with width \(width) - height \(height) - weight \(fontWeight). Found it in DB, size is \(objList[0].fontSize)")
            return (objList[0].fontSize, isPredicted)
        }
        
    }
    
    func CalcBestSizeForString()-> (Int16, [CGFloat], [Int]){
        var predictList: [Int] = []
        var weightArray:[CGFloat] = []
        var weightArrayForSave: [CGFloat] = []
        //Find weight for each character
        for (index, char) in self.charArray.enumerated(){
            if char.isNumber || char.isLetter{
                //font.weight to fontWeight string, for searching
                var _fontWeight = ""
                if fontWeight == .regular {
                    _fontWeight = "regular"
                }
                else if fontWeight == .semibold{
                    _fontWeight = "semibold"
                }
                //print("  \(charRects[index].width)")
                var singleChar = CalcSizeForSingleChar(String(char), Int16(charRects[index].width.rounded()), Int16(charRects[index].height.rounded()), _fontWeight)
                var tempweight = singleChar.0
                if (tempweight != 0){
                    weightArray.append(CGFloat(tempweight))
                }
                
                if(tempweight > 0){
                    weightArrayForSave.append(CGFloat(tempweight))
                    predictList.append(singleChar.1)
                }else{
                    weightArrayForSave.append(-1)
                    predictList.append(0)
                }
            }else{
                weightArrayForSave.append(-1)
                predictList.append(0)
            }
        }
        //return FindBestWeightFromWeightArray(FromArray: weightArray)
        var floatSize = FindBestSizeFromArray(FromArray: weightArray)
        let nearResult = CharDataManager.FetchNearestOne(AppDelegate().persistentContainer.viewContext, fontSize: Int16(floatSize.rounded()))
        let nearResult1 = OSStandardManager.FetchNearestOne(AppDelegate().persistentContainer.viewContext, fontSize: Int16(floatSize.rounded())) //Fetch nearest item from standard table
        return  (nearResult1.fontSize == 0 ? nearResult.fontSize : nearResult1.fontSize, weightArrayForSave, predictList)
    }

    private func FindBestSizeFromArray(FromArray sizeArray: [CGFloat]) -> Float{
        var sizeDict: [Int16: Int16] = [:]
        for w in sizeArray{
            let keyExists = sizeDict[Int16(round(w))] != nil
            if keyExists == false { //If the weight is new
                sizeDict[Int16(round(w))] = 1
            }
            else{
                let index = sizeDict[Int16(round(w))]
                sizeDict[Int16(round(w))] = index! + 1
            }
        }
        let sortedValue = sizeDict.values.sorted(by: >)
        let filtered = sizeDict.filter { $0.1 ==  sortedValue[0] }
        var result: Float = 0.0
        for (key, value) in filtered{
            result = result + Float(key)
        }
        result = result / Float(filtered.count)
        return result
    }

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
    
    mutating func PredictFontWeight()->Font.Weight{
        charFontWeightList.removeAll()
        for img in charImageList{
            let temp = FontWeightPredict().Prediction(ciImage: img)
            if (temp == "semibold"){
                charFontWeightList.append(Font.Weight.semibold)
            }else if (temp == "regular"){
                charFontWeightList.append(Font.Weight.regular)
            }else{
                charFontWeightList.append(Font.Weight.black)
            }
        }
        var result: Font.Weight = Font.Weight.regular
        
        if (charFontWeightList.count > 0){
            result = charFontWeightList.MajorityElement()
        }
        return result
    }
    
    
    
    
    
}


