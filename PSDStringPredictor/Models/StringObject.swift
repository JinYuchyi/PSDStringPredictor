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
struct StringObject : Identifiable, Equatable, Hashable{
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func == (lhs: StringObject, rhs: StringObject) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.content == rhs.content &&
            lhs.tracking == rhs.tracking &&
            lhs.trackingPS == rhs.trackingPS &&
            lhs.fontSize == rhs.fontSize &&
            lhs.fontWeight == rhs.fontWeight &&
            lhs.stringRect == rhs.stringRect &&
            lhs.observation == rhs.observation &&
            lhs.color == rhs.color &&
            lhs.charArray == rhs.charArray &&
            lhs.charRects == rhs.charRects &&
            lhs.charSizeList == rhs.charSizeList &&
            lhs.charImageList == rhs.charImageList &&
            lhs.isPredictedList == rhs.isPredictedList &&
            lhs.isForbidden == rhs.isForbidden
    }
    
    
    var id: UUID
    var content: String
    //var position: [CGFloat]
    var tracking: CGFloat
    var trackingPS: Int16
    var fontSize: CGFloat
    var fontWeight:  Font.Weight
    var stringRect: CGRect
    var observation : VNRecognizedTextObservation
    var color: CGColor
    var charArray: [Character]
    var charRects: [CGRect]
    var charSizeList: [Int16]
    var charImageList: [CIImage]
    var charFontWeightList: [Font.Weight]
    var isPredictedList: [Int]
    var isForbidden: Bool
    var confidence: CGFloat
    var colorMode: Int
    var charColorModeList: [Int]
    
    //@EnvironmentObject var db: DB
    let ocr: OCR = OCR()
    let fontUtils = FontUtils()
    let db = DB.shared
    //var stringObjectList: [StringObject]
    
    init(){
        id = UUID()
        content = "No content."
        //position = []
        tracking = 0
        fontSize = 0
        colorMode = -1
        fontWeight =  Font.Weight.regular
        charImageList = []
        stringRect = CGRect()
        observation = VNRecognizedTextObservation.init()
        color = CGColor.black
        charArray = []
        charRects = []
        charSizeList = []
        charFontWeightList = []
        confidence = 0
        isForbidden = false
        charColorModeList = []
        self.trackingPS = 0
        isPredictedList = []
        self.fontWeight = PredictFontWeight()
        colorMode = CalcColorMode()
        self.color = CalcColor() ?? CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    init(_ content: String, _ stringRect: CGRect, _ observation: VNRecognizedTextObservation, _ charArray: [Character], _ charRacts: [CGRect], charImageList: [CIImage], _ confidence: CGFloat){
        id = UUID()
        colorMode = -1
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
        self.color = CGColor.black
        self.confidence = confidence
        self.isPredictedList = []
        self.trackingPS = 0
        isForbidden = false
        charColorModeList = []
        self.fontWeight = PredictFontWeight()
        let sizeFunc = CalcBestSizeForString()
        self.fontSize = CGFloat(sizeFunc.0)
        self.tracking = FetchTrackingFromDB(self.fontSize).0
        self.trackingPS = FetchTrackingFromDB(self.fontSize).1
        
        self.charSizeList = sizeFunc.1
        self.isPredictedList = sizeFunc.2
        colorMode = CalcColorMode()
        self.color = CalcColor() ?? CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    mutating func CalcColorMode() -> Int{
        var result = -1
        for img in charImageList{
            let bw = SetGrayScale(img)
            
            let charColorMode = CharColorModeClassifier()
            let result = charColorMode.Prediction(fromImage: bw!)
            charColorModeList.append(result)
        }
        if charColorModeList.count > 0 {
            result = charColorModeList.MajorityElement()
        }
        return result
    }
    
    func FixContent(_ target: String) -> String{
        var res: String = target
        let lowerString: String = target.lowercased()
        for _word in DataStore.wordList{
            //Condition which we need to fix lowercase/uppercase problem for proper nouns, such as "iCloud".
            if (lowerString.contains(_word.lowercased()) == true && lowerString.contains(_word) == false ){
                let range = lowerString.range(of: _word.lowercased())
                let first = range?.lowerBound
                let last = range?.upperBound
                res = target.replacingOccurrences(of: target[first!...last!], with: _word)
            }
        }
        return res
    }
    
    func FetchTrackingFromDB(_ size: CGFloat) -> (CGFloat, Int16){
        let item = TrackingDataManager.FetchNearestOne(AppDelegate().persistentContainer.viewContext, fontSize: Int16(size.rounded()))
        //return CGFloat(item.fontTracking)/1000
        //print("item.fontTrackingPoints ",item.fontTrackingPoints)
        //return CGFloat(item.fontTrackingPoints)
        return (CGFloat(item.fontTrackingPoints), item.fontTracking)
    }
    
    func PredictTracking()->Double{
        var trackings: [Double] = []
        for index in 0..<charArray.count{
            if (index + 1 < charArray.count && charArray[index].isLetter && charArray[index+1].isLetter){
                let strs: String = String(charArray[index]) + String(charArray[index+1])
                let _width = fabs(charRects[index].minX - charRects[index+1].maxX) / fontSize * 12
                let _fontWeight = "SFProText-Regular"
                let tmp = PredictFontTracking(str: strs, fontSize: Double(fontSize), width: Double(_width), fontWeight: _fontWeight)
                //print("Predicting \(strs) - fontsize: \(fontSize) - width: \(_width) - result: \(tmp) ")
                trackings.append(tmp)
            }
        }
        let result: Double = trackings.MajorityElement()
        //print("Predict tracking: \(result)")
        return result
    }
    
    func CalcColor() -> CGColor? {
        var colorList: [NSColor] = []
        var result: CGColor = CGColor.init(red: 1, green: 1, blue: 0, alpha: 1)
        var maxC: CGColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        var minC: CGColor =  CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        if charImageList.count > 0{
            if colorMode == 1{
                var strImg = DataStore.targetNSImage.ToCIImage()?.cropped(to: CGRect(x: stringRect.origin.x, y: stringRect.origin.y, width: stringRect.width.rounded(.towardZero) , height: stringRect.height.rounded(.towardZero)))
                strImg = NoiseReduction(strImg!)
                result = Minimun(strImg!).cgColor
                
            }
            if colorMode == 2{
                var strImg = DataStore.targetNSImage.ToCIImage()?.cropped(to: CGRect(x: stringRect.origin.x, y: stringRect.origin.y, width: stringRect.width.rounded(.towardZero) , height: stringRect.height.rounded(.towardZero)))
                strImg = NoiseReduction(strImg!)
                result = Maximum(strImg!).cgColor
            }
        }
        return result
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
    
    func CalcFontFullName() -> String{
        var family = ""
        var style = ""
        if (fontWeight == .regular){
            style = "Regular"
        }
        else if fontWeight == .semibold{
            style = "Semibold"
        }
        
        if fontSize/3 < 20 {
            family = "Text"
        }else{
            family = "Display"
        }
        return "SF Pro " + family + " " + style
    }
    
    func CalcFontPostScriptName() -> String{
        var family = ""
        var style = ""
        if (fontWeight == .regular){
            style = "Regular"
        }
        else if fontWeight == .semibold{
            style = "Semibold"
        }
        
        if fontSize/3 < 20 {
            family = "Text"
        }else{
            family = "Display"
        }
        return "SFPro" + family + "-" + style
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
            let fontName = CalcFontFullName()
            descent = FontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize).descent
            descent = descent * 0.8
        }
        
        
        stringRect = CGRect(x: stringRect.origin.x, y: stringRect.origin.y + descent, width: stringRect.width, height: stringRect.height - descent)
        
        
    }
    
    func CalcSizeForSingleChar(_ char: String, _ width: Int16, _ height: Int16, _ fontWeight: String) -> (Int16, Int){
        var isPredicted = 0
        var result: Int16 = 0
        
        var keyvalues: [String: AnyObject] = [:]
        keyvalues["char"] = char as AnyObject
        keyvalues["width"] = width as AnyObject
        keyvalues["height"] = height as AnyObject
        keyvalues["fontWeight"] = fontWeight as AnyObject
        let objList = CharDataManager.FetchItems(AppDelegate().persistentContainer.viewContext, keyValues: keyvalues)
        
        if (objList.count == 0){
            isPredicted = 1
            //print("\(char), with width \((width)) - height \((height)) - weight \(fontWeight). Pridict it as \(PredictFontSize(character: char, width: (width), height: (height), fontWeight: fontWeight))")
            return (Int16(PredictFontSize(character: char, width: (width), height: (height), fontWeight: fontWeight).rounded()), isPredicted)
        }else{
            isPredicted = -1
            //print("\(char), with width \(width) - height \(height) - weight \(fontWeight). Found it in DB, size is \(objList[0].fontSize)")
            return (objList[0].fontSize, isPredicted)
        }
        
    }
    
    func CalcBestSizeForString()-> (Int16, [Int16], [Int]){
        var predictList: [Int] = []
        var weightArray:[Int16] = []
        var weightArrayForSave: [Int16] = []
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
                var singleChar = CalcSizeForSingleChar(String(char), Int16(charRects[index].width.rounded()), Int16(charRects[index].height.rounded()), _fontWeight)
                var tempweight = singleChar.0
                if (tempweight != 0){
                    weightArray.append((tempweight))
                }
                
                if(tempweight > 0){
                    weightArrayForSave.append((tempweight))
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
        var size = FindBestSizeFromArray(FromArray: weightArray)
        //        let nearResult = CharDataManager.FetchNearestOne(AppDelegate().persistentContainer.viewContext, fontSize: (floatSize))
        //        let nearResult1 = OSStandardManager.FetchNearestOne(AppDelegate().persistentContainer.viewContext, fontSize: (floatSize)) //Fetch nearest item from standard table
        //        return  (nearResult1.fontSize == 0 ? nearResult.fontSize : nearResult1.fontSize, weightArrayForSave, predictList)
        return (size, weightArrayForSave, predictList)
    }
    
    private func FindBestSizeFromArray(FromArray sizeArray: [Int16]) -> Int16{
        var sizeDict: [Int16: Int16] = [:]
        for w in sizeArray{
            let keyExists = sizeDict[w] != nil
            if keyExists == false { //If the weight is new
                sizeDict[w] = 1
            }
            else{
                let index = sizeDict[w]
                sizeDict[w] = index! + 1
            }
        }
        let sortedValues = sizeDict.values.sorted(by: >)
        let filtered = sizeDict.filter { $0.1 ==  sortedValues[0] }
        
        var res: Int16 = 0
        for item in sizeDict.keys{
            if sizeDict[item] == sortedValues[0]{
                res = item
            }
        }
        return res
        
    }
    
    func PredictStringObjects(FromCIImage img: CIImage) -> [StringObject]{
        //data.targetImageSize = [Int64(img.extent.width), Int64(img.extent.height)]
        
        if img.extent.width > 0{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: img )
            DataStore.stringObjectList = stringObjects
            return stringObjects
        }
        else{
            print("Load Image failed.")
            return []
        }
    }
    
    mutating func PredictFontWeight()->Font.Weight{
        charFontWeightList.removeAll()
        for img in charImageList{
            let bw = SetGrayScale(img)
            let temp = FontWeightPredict().Prediction(ciImage: bw!)
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
    
    mutating func SetForbidden(_ f: Bool){
        isForbidden = f
    }
    
}


