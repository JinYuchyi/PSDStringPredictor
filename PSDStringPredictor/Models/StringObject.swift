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

enum StringAlignment:String, CaseIterable{
    case left, center, right
}
extension StringAlignment{
    func index () -> Int {
        switch self {
            case .left: return 1
            case .center: return 2
            case .right: return 3
        }
    }
}

//struct StringObject: Hashable, Codable, Identifiable {
struct StringObject : Identifiable, Equatable, Hashable{

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
            //lhs.observation == rhs.observation &&
            lhs.color == rhs.color &&
            lhs.charArray == rhs.charArray &&
            lhs.charRects == rhs.charRects &&
            lhs.charSizeList == rhs.charSizeList &&
            lhs.charImageList == rhs.charImageList &&
            lhs.isPredictedList == rhs.isPredictedList
            //lhs.isForbidden == rhs.isForbidden
    }
    
    
    var id: UUID
    var content: String
    //var position: [CGFloat]
    var tracking: CGFloat
    var trackingPS: Int16
    var fontSize: CGFloat
    var fontWeight:  String
    var stringRect: CGRect
    //var observation : VNRecognizedTextObservation
    var color: CGColor
    var charArray: [Character]
    var charRects: [CGRect]
    var charSizeList: [Int16]
    var charImageList: [CIImage]
    var charFontWeightList: [String]
    var isPredictedList: [Int]
    //var isForbidden: Bool
    var confidence: CGFloat
    var colorMode: MacColorMode
    var charColorModeList: [Int]
    var FontName: String
    var alignment: StringAlignment
    var status: StringObjectStatus //0: Normal 1: Fix 2: Ignore
    var isParagraph: Bool = false
    let ocr: OCR = OCR()
    let fontUtils = FontUtils()

    init(){
        self.id = UUID()
        self.content = "No content."
        //position = []
        self.tracking = 0
        self.fontSize = 0
        self.colorMode = .light
        self.fontWeight =  ""
        self.charImageList = []
        self.stringRect = CGRect()
        //self.observation = VNRecognizedTextObservation.init()
        self.color = CGColor.black
        self.charArray = [" "]
        self.charRects = [CGRect()]
        self.charSizeList = [0]
        self.charFontWeightList = ["Regular"]
        self.confidence = 0
        //self.isForbidden = false
        self.charColorModeList = [0]
        self.trackingPS = 0
        self.isPredictedList = [0]
        self.FontName = ""
        self.alignment = .left
        self.status = .normal
        self.FontName = CalcFontFullName()
        self.fontWeight = PredictFontWeight()
        self.colorMode = CalcColorMode()
        self.color = CalcColor() ?? CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    init(_ content: String, _ stringRect: CGRect, _ charArray: [Character], _ charRacts: [CGRect], charImageList: [CIImage], _ confidence: CGFloat){
        
        id = UUID()
        self.content = content
        self.tracking = 10
        self.fontSize = 0.0
        self.colorMode = .light
        self.fontWeight = "Regular"
        self.charImageList = charImageList
        self.stringRect = stringRect
        //self.observation = observation
        self.color = CGColor.black
        self.charArray = charArray
        self.charRects = charRacts
        self.charSizeList = []
        self.charFontWeightList = []
        self.confidence = confidence
        //self.isForbidden = false
        self.charColorModeList = []
        self.trackingPS = 0
        self.isPredictedList = []
        self.FontName = ""
        self.alignment = .left
        self.status = .normal
        self.FontName = CalcFontFullName()
        self.fontWeight = PredictFontWeight()
        self.colorMode = CalcColorMode()
        self.color = CalcColor() ?? CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        let sizeFunc = CalcBestSizeForString()
        self.fontSize = CGFloat(sizeFunc.0)
        self.tracking = FetchTrackingFromDB(self.fontSize).0
        self.trackingPS = FetchTrackingFromDB(self.fontSize).1
        self.charSizeList = sizeFunc.1
        self.isPredictedList = sizeFunc.2
    }
    
//    mutating func ToggleColorMode(){
//        if colorMode == 1 {
//            colorMode = 2
//        }else if colorMode == 2{
//            colorMode = 1
//        }
//    }
    
//    func FetchCharImageList(){
//        targetImageProcessed.GetCroppedImages(rects: charRects)
//    }
    
    mutating func CalcColorMode() -> MacColorMode{
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
        if result == 1{
            return .light
        }else{
            return .dark
        }
        //return result
    }
    
    mutating func SetOffset(x: CGFloat, y: CGFloat){
        var result: [CGRect] = []
        for cr in charRects {
            let tmp = CGRect.init(x: cr.minX + x, y: cr.minY + y, width: cr.width, height: cr.height)
            result.append(tmp)
        }
        charRects = result
        
        stringRect = CGRect.init(x: stringRect.minX + x, y: stringRect.minY + y, width: stringRect.width, height: stringRect.height)
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
    
//    func PredictTracking()->Double{
//        var trackings: [Double] = []
//        for index in 0..<charArray.count{
//            if (index + 1 < charArray.count && charArray[index].isLetter && charArray[index+1].isLetter){
//                let strs: String = String(charArray[index]) + String(charArray[index+1])
//                let _width = fabs(charRects[index].minX - charRects[index+1].maxX) / fontSize * 12
//                let _fontWeight = "SFProText-Regular"
//                let tmp = PredictFontTracking(str: strs, fontSize: Double(fontSize), width: Double(_width), fontWeight: _fontWeight)
//                trackings.append(tmp)
//            }
//        }
//        let result: Double = trackings.MajorityElement()
//        return result
//    }
    
    func CalcColor() -> CGColor {
        //var colorList: [NSColor] = []
        //let colorSpace: NSColorSpace = .genericRGB
        //var color: NSColor = NSColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        var result: CGColor = CGColor.init(srgbRed: 1, green: 1, blue: 0, alpha: 1)
        var minc = NSColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        var maxc = NSColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        var nsColor = NSColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        if charImageList.count > 0{
            if colorMode == .light{
                //old
//                let strImg = PsdsUtil.shared.GetSelectedNSImage().ToCIImage()!.cropped(to: CGRect(x: stringRect.origin.x, y: stringRect.origin.y, width: stringRect.width.rounded(.towardZero) , height: stringRect.height.rounded(.towardZero)))
//                nsColor = Minimun(strImg)
//                result = CGColor.init(red: nsColor.redComponent, green: nsColor.greenComponent, blue: nsColor.blueComponent, alpha: 1)
                
                //New

                 
                for img in charImageList{
                    if Minimun(img).brightnessComponent <  minc.brightnessComponent  {
                        minc = Minimun(img)
                    }
                }
                result = CGColor.init(srgbRed: minc.redComponent, green: minc.greenComponent, blue: minc.blueComponent, alpha: 1)
                
            }
            if colorMode == .dark{
                //old
//                let strImg = PsdsUtil.shared.GetSelectedNSImage().ToCIImage()?.cropped(to: CGRect(x: stringRect.origin.x, y: stringRect.origin.y, width: stringRect.width.rounded(.towardZero) , height: stringRect.height.rounded(.towardZero)))
//                result = CGColor.init(red: nsColor.redComponent, green: nsColor.greenComponent, blue: nsColor.blueComponent, alpha: 1)
                
                //new
                for img in charImageList{
                    if Maximum(img).brightnessComponent >  maxc.brightnessComponent  {
                        maxc = Maximum(img)
                    }
                }
                result = CGColor.init(srgbRed: maxc.redComponent, green: maxc.greenComponent, blue: maxc.blueComponent, alpha: 1)
            }
        }
        //SnapToNearestStandardColor(result)
        //print("content: \(content), ns: \(nsColor), re: \(result)")
        return result
    }
    
//    func SnapToNearestStandardColor(_ cl: CGColor){
//        let fixed  = imageProcessViewModel.FindNearestStandardRGB(cl)
//        print(fixed)
//    }
    
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
        //var style = ""
//        if (fontWeight == .regular){
//            style = "Regular"
//        }
//        else if fontWeight == .semibold{
//            style = "Semibold"
//        }
        
        if fontSize/3 < 20 {
            family = "Text"
        }else{
            family = "Display"
        }
        
        let name = "SF Pro " + family + " " + fontWeight
        //FontName = name
        return name
    }
    
     func CalcFontFullName(weight: String) -> String{
        var family = ""
        var style = ""
        
        style = weight
        
        if fontSize/3 < 20 {
            family = "Text"
        }else{
            family = "Display"
        }
        let name =  "SF Pro " + family + " " + style
        //FontName = name
        return name
    }
    
    func CalcFontPostScriptName() -> String{
        var family = ""
        //var style = ""
//        if (fontWeight == .regular){
//            style = "Regular"
//        }
//        else if fontWeight == .semibold{
//            style = "Semibold"
//        }
        
        if fontSize/3 < 20 {
            family = "Text"
        }else{
            family = "Display"
        }
        return "SFPro" + family + "-" + fontWeight
    }
    
//    mutating func DeleteDescentForRect()  {
//        var highLetterEvenHeight: CGFloat = 0
//        var lowerLetterEvenHeight: CGFloat = 0
//        var fontName: String = ""
//        if (fontSize >= 20) {
//            fontName = "SFProDisplay-Regular"
//        }
//        else{
//            fontName = "SFProText-Regular"
//        }
//        
//        //Condition of if has p,q,g,y,j character in string,
//        //We have to adjust string position and size
//        var n: CGFloat = 0
//        var n1: CGFloat = 0
//        var hasLongTail = false
//        for (index, c) in charArray.enumerated() {
//            if (
//                c == "p" ||
//                    c == "q" ||
//                    c == "g" ||
//                    c == "y" ||
//                    c == "j" ||
//                    c == "," ||
//                    c == ";"
//            ) {
//                hasLongTail = true
//            }
//        }
//        
//        var descent: CGFloat = 0
//        if hasLongTail == true{
//            let fontName = CalcFontFullName()
//            descent = FontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize).descent
//            descent = descent * 0.8
//        }
//        
//        
//        stringRect = CGRect(x: stringRect.origin.x, y: stringRect.origin.y + descent, width: stringRect.width, height: stringRect.height - descent)
//        
//        
//    }
    
    func CalcSizeForSingleChar(_ char: String, _ width: Int16, _ height: Int16, _ fontWeight: String) -> (Int16, Int){
        var isPredicted = 0
        //var result: Int16 = 0
        
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
                //var _fontWeight = ""
//                if fontWeight == .regular {
//                    _fontWeight = "regular"
//                }
//                else if fontWeight == .semibold{
//                    _fontWeight = "semibold"
//                }
                let singleChar = CalcSizeForSingleChar(String(char), Int16(charRects[index].width.rounded()), Int16(charRects[index].height.rounded()), fontWeight)
                let tempweight = singleChar.0
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
        let size = FindBestSizeFromArray(FromArray: weightArray)
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
        
        var res: Int16 = 0
        for item in sizeDict.keys{
            if sizeDict[item] == sortedValues[0]{
                res = item
            }
        }
        return res
        
    }
    

    
    mutating func PredictFontWeight()->String{
        charFontWeightList.removeAll()
        for img in charImageList{
            let bw = SetGrayScale(img)
            let temp = FontWeightPredict().Prediction(ciImage: bw!)
            if (temp == "semibold"){
                charFontWeightList.append("Semibold")
            }else if (temp == "regular"){
                charFontWeightList.append("Regular")
            }else{
                charFontWeightList.append("Black")
            }
        }
        var result: String = "Regular"
        
        if (charFontWeightList.count > 0){
            result = charFontWeightList.MajorityElement()
        }
        return result
    }
    
//    mutating func SetForbidden(_ f: Bool){
//        isForbidden = f
//    }
    
}


