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

let zeroStringObject = StringObject.init()

//struct StringObject: Hashable, Codable, Identifiable {
struct StringObject : Identifiable,  Hashable{

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
//    static func == (lhs: StringObject, rhs: StringObject) -> Bool {
//        return
//            lhs.id == rhs.id &&
//            lhs.content == rhs.content &&
//            lhs.tracking == rhs.tracking &&
////            lhs.trackingPS == rhs.trackingPS &&
//            lhs.fontSize == rhs.fontSize &&
//            lhs.fontWeight == rhs.fontWeight &&
//            lhs.stringRect == rhs.stringRect &&
//            //lhs.observation == rhs.observation &&
//            lhs.color == rhs.color &&
//            lhs.charArray == rhs.charArray &&
//            lhs.charRects == rhs.charRects &&
//            lhs.charSizeList == rhs.charSizeList &&
//            lhs.charImageList == rhs.charImageList &&
//            lhs.isPredictedList == rhs.isPredictedList
//            //lhs.isForbidden == rhs.isForbidden
//    }
    
    
    var id: UUID
    var content: String
    var tracking: CGFloat
    var fontSize: CGFloat
    var fontWeight:  String
    var stringRect: CGRect
    var color: CGColor
    var bgColor: CGColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
    var charArray: [Character]
    var charRects: [CGRect]
    var charSizeList: [Int16]
    var charImageList: [CIImage]
    var charFontWeightList: [String]
    var isPredictedList: [Int]
    var colorMode: MacColorMode
    var charColorModeList: [Int]
    var FontName: String
    var alignment: StringAlignment
    var status: StringObjectStatus //0: Normal 1: Fix 2: Ignore
    var isParagraph: Bool = false
    var colorPixel: CIImage = CIImage.init()

    init(){
        self.id = UUID()
        self.content = "No content."
        //position = []
        self.tracking = 0
        self.fontSize = 0
        self.colorMode = .light
        self.fontWeight =  "Regular"
        self.charImageList = [CIImage.init()]
        self.stringRect = CGRect()
        self.color = CGColor.init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        self.charArray = [" "]
        self.charRects = [CGRect()]
        self.charSizeList = [0]
        self.charFontWeightList = ["Regular"]
        self.charColorModeList = [0]
        self.isPredictedList = [0]
        self.FontName = "SF Pro Text Regular"
        self.alignment = .left
        self.status = .normal
//        self.FontName = CalcFontFullName()
//        self.fontWeight = PredictFontWeight()
        self.colorMode = .light
//        self.color = CalcColor()
    }
    
    init(_ content: String, _ stringRect: CGRect, _ charArray: [Character], _ charRacts: [CGRect], charImageList: [CIImage]){
        
        id = UUID()
        self.content = content
        self.tracking = 10
        self.fontSize = 0.0
        self.colorMode = .light
        self.fontWeight = "Regular"
        self.charImageList = charImageList
        self.stringRect = stringRect
        self.color = CGColor.init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        self.charArray = charArray
        self.charRects = charRacts
        self.charSizeList = []
        self.charFontWeightList = ["Regular"]
        self.charColorModeList = []
        self.isPredictedList = []
        self.FontName = ""
        self.alignment = .left
        self.status = .normal
        self.FontName = CalcFontFullName()
        self.fontWeight = PredictFontWeight()
        self.colorMode = CalcColorMode()
        self.color = CalcColor()
        let sizeFunc = CalcBestSizeForString()
        self.fontSize = CGFloat(sizeFunc.0)
        self.tracking = FetchTrackingFromDB(self.fontSize).0

        self.charSizeList = sizeFunc.1
        self.isPredictedList = sizeFunc.2
    }
    
    init(id: UUID, tracking: CGFloat, fontSize: CGFloat, colorMode: MacColorMode, fontWeight: String, charImageList: [CIImage], color: CGColor, bgColor: CGColor, charArray: [Character], charRacts: [CGRect], charSizeList: [Int16], charFontWeightList: [String], charColorModeList: [Int], isPredictedList: [Int], fontName: String, alignment: StringAlignment, status: StringObjectStatus){
        
        self.id = id
//        self.content = content
        self.tracking = tracking
        self.fontSize = fontSize
        self.colorMode = colorMode
        self.fontWeight = fontWeight
        self.charImageList = charImageList
//        self.stringRect = stringRect
        self.color = color
        self.bgColor = bgColor
        self.charArray = charArray
        self.charRects = charRacts
        self.charSizeList = charSizeList
        self.charFontWeightList = charFontWeightList
        self.charColorModeList = charColorModeList
        self.isPredictedList = isPredictedList
        self.FontName = fontName
        self.alignment = alignment
        self.status = status
        self.stringRect = CGRect.init()
        self.content = String(charArray)
        self.stringRect = mergeRect(rects: charRacts)

    }
    
    init(id: UUID, content: String, tracking: CGFloat, fontSize: CGFloat, colorMode: String, fontWeight: String, charImageList: [CIImage], stringRect: CGRect, color: [CGFloat], bgColor: [CGFloat], charArray: [String], charRacts: [CGRect], charSizeList: [Int16], charFontWeightList: [String], charColorModeList: [Int], isPredictedList: [Int], fontName: String, alignment: String, status: String){
        
        self.id = id
        self.content = content
        self.tracking = tracking
        self.fontSize = fontSize
        self.colorMode = MacColorMode(rawValue: colorMode)!
        self.fontWeight = fontWeight
        self.charImageList = charImageList 
        self.stringRect = stringRect
        self.color = color.toCGColor()
        self.bgColor = bgColor.toCGColor()
        self.charArray = charArray.map({Array($0)[0]})
        self.charRects = charRacts
        self.charSizeList = charSizeList
        self.charFontWeightList = charFontWeightList
        self.charColorModeList = charColorModeList
        self.isPredictedList = isPredictedList
        self.FontName = fontName
        self.alignment = StringAlignment.init(rawValue: alignment)!
        self.status = StringObjectStatus.init(rawValue: status)!
    }
    
    func mergeRect(rects: [CGRect]) -> CGRect{
        let maxHeight = rects.map({$0.height}).max()!
        return CGRect.init(x: rects[0].minX, y: rects[0].minY, width: rects.last!.maxX - rects[0].minX, height: maxHeight)
    }
    
    mutating func CalcColorMode() -> MacColorMode{
        var result = -1
        charColorModeList = []
        for index in 0..<charArray.count{
            let bw = SetGrayScale(charImageList[index])
            
            let charColorMode = CharColorModeClassifierV2.init()
            let result = charColorMode.Prediction(fromImage: bw!, char: String(charArray[index]))
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
    

    mutating func CalcColor() -> CGColor {
        //var colorList: [NSColor] = []
        //let colorSpace: NSColorSpace = .genericRGB
        //var color: NSColor = NSColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        print("Calc color for \(content)")
        var result: CGColor = CGColor.init(srgbRed: 1, green: 1, blue: 0, alpha: 1)
       
        //var nsColor = NSColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        if charImageList.count > 0{
            if colorMode == .light{
                
                var minc = NSColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                var maxc = NSColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
                
                for img in charImageList.filter({$0.extent.width > 0}){
                    //Calculate the darkest color as the font color
                    if Minimun(img).0.brightnessComponent <  minc.brightnessComponent  {
                        minc = Minimun(img).0
                        colorPixel = Minimun(img).1
                        print("Clac text color, char min: \(minc)")
                    }
                    //Calculate the brightest color as the background color
                    if Maximum(img).0.brightnessComponent >  maxc.brightnessComponent  {
                        maxc = Maximum(img).0
                        print("Clac bg color, char max: \(maxc)")
                    }
                }
                bgColor = CGColor.init(srgbRed: maxc.redComponent, green: maxc.greenComponent, blue: maxc.blueComponent, alpha: 1)
                result = CGColor.init(srgbRed: minc.redComponent, green: minc.greenComponent, blue: minc.blueComponent, alpha: 1)
                
            }
            if colorMode == .dark{
                var minc = NSColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                var maxc = NSColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
                for img in charImageList.filter({$0.extent.width > 0}){
                    //Calculate the brightest color as the font color
                    if Maximum(img).0.brightnessComponent >  maxc.brightnessComponent  {
                        maxc = Maximum(img).0
                        colorPixel = Maximum(img).1
                        print("Clac text color, char max: \(maxc)")
                    }
                    //Calculate the darkest color as the background color
                    if Minimun(img).0.brightnessComponent <  minc.brightnessComponent  {
                        minc = Minimun(img).0
                        print("Clac bg color, char min: \(minc)")

                    }
                }
                bgColor = CGColor.init(srgbRed: minc.redComponent, green: minc.greenComponent, blue: minc.blueComponent, alpha: 1)
                result = CGColor.init(srgbRed: maxc.redComponent, green: maxc.greenComponent, blue: maxc.blueComponent, alpha: 1)
            }
        }

        color = result
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

    func CalcSizeForSingleChar(_ char: String, _ width: Int16, _ height: Int16, _ fontWeight: String) -> (Int16, Int){
        var isPredicted = 0
        //var result: Int16 = 0
        let _weight = fontWeight.lowercased()
        var keyvalues: [String: AnyObject] = [:]
        keyvalues["char"] = char as AnyObject
        keyvalues["width"] = width as AnyObject
        keyvalues["height"] = height as AnyObject
        keyvalues["fontWeight"] = _weight as AnyObject
        
        let objList = CharDataManager.FetchItems(AppDelegate().persistentContainer.viewContext, keyValues: keyvalues)
        
        if (objList.count == 0){
            isPredicted = 1
            //print("\(char), with width \((width)) - height \((height)) - weight \(_weight). Pridict it as \(PredictFontSize(character: char, width: (width), height: (height), fontWeight: _weight))")
            return (Int16(PredictFontSize(character: char, width: (width), height: (height), fontWeight: _weight).rounded()), isPredicted)
        }else{
            isPredicted = -1
            //print("\(char), with width \(width) - height \(height) - weight \(_weight). Found it in DB, size is \(objList[0].fontSize)")
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


