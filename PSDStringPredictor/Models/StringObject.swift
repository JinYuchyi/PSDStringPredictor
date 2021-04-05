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

let zeroStringObject = StringObject.init()
let defaultAlignment = StringAlignment.left

//struct StringObject: Hashable, Codable, Identifiable {
struct StringObject : Identifiable,  Hashable{

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
    }
    
    
    var id: UUID
    var imagePath: String
    var content: String
    var tracking: CGFloat
    var fontSize: CGFloat
    var fontWeight:  String
    var stringRect: CGRect
    var color: CGColor
    var bgColor: CGColor = CGColor.init(red: 0, green: 0, blue: 1, alpha: 1)
    var charArray: [Character]
    var charRects: [CGRect]
    var charSizeList: [Int16]
    var charImageList: [CIImage]
    var charFontWeightList: [String]
    var isPredictedList: [Int]
    var colorMode: MacColorMode
    var charColorModeList: [Int]
    var fontName: String
    var alignment: StringAlignment
    var status: StringObjectStatus //0: Normal 1: Fix 2: Ignore
    var isParagraph: Bool = false
    
    
//    var colorPixel: CIImage = CIImage.init()

    init(){
        self.id = UUID()
        imagePath =  ""
        self.content = "No content."
        self.tracking = 0
        self.fontSize = 0
        self.colorMode = .light
        self.fontWeight =  "Regular"
        self.charImageList = [DataStore.zeroCIImage]
        self.stringRect = CGRect()
        self.color = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        self.charArray = [" "]
        self.charRects = [CGRect()]
        self.charSizeList = [0]
        self.charFontWeightList = ["Regular"]
        self.charColorModeList = [0]
        self.isPredictedList = [0]
        self.fontName = "SF Pro Text Regular"
        self.alignment = defaultAlignment
        self.status = .normal
        self.colorMode = .light
    }
    
    init(imagePath: String,  _ content: String, _ stringRect: CGRect, _ charArray: [Character], _ charRacts: [CGRect], charImageList: [CIImage]){
        
        id = UUID()
        self.imagePath = imagePath
        self.content = content
        self.tracking = 10
        self.fontSize = 0.0
        self.colorMode = .light
        self.fontWeight = "Regular"
        self.charImageList = charImageList
        self.stringRect = stringRect
        self.color = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
        self.charArray = charArray
        self.charRects = charRacts
        self.charSizeList = [0]
        self.charFontWeightList = ["Regular"]
        self.charColorModeList = [0]
        self.isPredictedList = [0]
        self.fontName = "SF Pro Text Regular"
        self.alignment = defaultAlignment
        self.status = .normal
        self.fontWeight = PredictFontWeight()
        self.colorMode = calcColorMode()
//        self.color = CalcColor()
        let sizeFunc = CalcBestSizeForString()
        self.fontSize = CGFloat(sizeFunc.0)
        self.fontName = CalcFontFullName()
        self.tracking = FetchTrackingFromDB(self.fontSize).0
        self.charSizeList = sizeFunc.1
        self.isPredictedList = sizeFunc.2
        self.content = FixContent(content)
        reCalcBound()
        calcColor()
    }
    
    init(id: UUID, imagePath: String, tracking: CGFloat, fontSize: CGFloat, colorMode: MacColorMode, fontWeight: String, charImageList: [CIImage], color: CGColor, bgColor: CGColor, charArray: [Character], charRacts: [CGRect], charSizeList: [Int16], charFontWeightList: [String], charColorModeList: [Int], isPredictedList: [Int], fontName: String, alignment: StringAlignment, status: StringObjectStatus){
        
        self.id = id
        self.imagePath = imagePath
        self.tracking = tracking
        self.fontSize = fontSize
        self.colorMode = colorMode
        self.fontWeight = fontWeight
        self.charImageList = charImageList
        self.color = color
        self.bgColor = bgColor
        self.charArray = charArray
        self.charRects = charRacts
        self.charSizeList = charSizeList
        self.charFontWeightList = charFontWeightList
        self.charColorModeList = charColorModeList
        self.isPredictedList = isPredictedList
        self.fontName = fontName
        self.alignment = alignment
        self.status = status
        self.stringRect = zeroRect
        self.content = String(charArray)
        self.stringRect = mergeRect(rects: charRacts)
//        self.content = FixContent(content)
//        calcColor()
    }
    
    init(id: UUID, imagePath: String,  content: String, tracking: CGFloat, fontSize: CGFloat, colorMode: String, fontWeight: String, charImageList: [CIImage], stringRect: CGRect, color: [CGFloat], bgColor: [CGFloat], charArray: [String], charRacts: [CGRect], charSizeList: [Int16], charFontWeightList: [String], charColorModeList: [Int], isPredictedList: [Int], fontName: String, alignment: String, status: String){
        
        self.id = id
        self.imagePath = imagePath
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
        self.fontName = fontName
        self.alignment = StringAlignment.init(rawValue: alignment)!
        self.status = StringObjectStatus.init(rawValue: status)!
//        self.content = FixContent(content)
//        calcColor()
    }
    
    mutating func reCalcBound(){
        let tmp  = FontUtils.GetStringBound(str: content, fontName: fontName, fontSize: fontSize, tracking: tracking)

        let width = tmp.width
        let height = tmp.height - FontUtils.FetchTailOffset(content: content, fontSize: fontSize)

        stringRect = CGRect.init(x: stringRect.minX, y: stringRect.minY, width: width, height: height)
    }
    
//    func reCalcRect(rect: CGRect) -> CGRect {
//        let bound = FontUtils.GetStringBound(str: content, fontName: FontName, fontSize: fontSize, tracking: tracking)
//        if Array(content).first!.isNumber == true || Array(content).first!.isLetter == true {
//            let firstChar = String(Array(content)[0])
//            let front = DataStore.frontSpaceDict[firstChar]
//            let r = CGRect.init(x: rect.minX + bound.minX - front!, y: rect.minY + bound.minY, width: bound.width, height: bound.height)
//            return r
//        }
//        return rect
//    }
    
    func mergeRect(rects: [CGRect]) -> CGRect{
        let maxHeight = rects.map({$0.height}).max()!
        return CGRect.init(x: rects[0].minX.rounded(), y: rects[0].minY.rounded(), width: (rects.last!.maxX - rects[0].minX).rounded(), height: maxHeight.rounded())
    }
    
    mutating func calcColorMode() -> MacColorMode{
        var result = -1
        charColorModeList = []
        for index in 0..<charArray.count{
            let bw = Filters.shared.SetGrayScale(charImageList[index])
            
//            let charColorMode = CharColorModeClassifierV2.init()
            let result = CharColorModeClassifierV2.shared.Prediction(fromImage: bw!, char: String(charArray[index]))
            charColorModeList.append(result)
        }
        if charColorModeList.count > 0 {
            result = charColorModeList.MajorityElement()
        }
        if result == 1{
//            self.colorMode = .light
            return .light
        }else if result == 2{
//            self.colorMode = .dark
            return .dark
        }else {
//            self.colorMode = .none
            return .none
        }
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
    

    
    mutating func FixContent(_ target: String) -> String{
        var res: String = target
        let lowerString: String = target.lowercased()
        //Condition which we need to fix lowercase/uppercase problem for proper nouns, such as "iCloud".
        for (typo, correct) in DataStore.wordDict{
            res = res.replacingOccurrences(of: typo, with: correct)
            self.content = res
            self.charArray = Array(res)
        }
        // 720 -> 72°
//        let targetMarkList = target.findZeroBehindNumberIndex()
//        if targetMarkList.count > 0 {
//
//        }
        // . -> ·
        let dotsList = target.findDots()
//        print("Dot found: \(dotsList)")
        var charList = Array(content)
        for _index in dotsList {
            if _index != 0 {
                print("1/3: \((self.stringRect.minY + self.stringRect.height / 3.0)), mid: \(self.charRects[_index].midY), 2/3: \((self.stringRect.minY + CGFloat(self.stringRect.height)) * 2.0 / 3.0 )")
                if ( self.charRects[_index].midY > (self.stringRect.minY + self.stringRect.height / 3.0) ) && ( CGFloat(self.charRects[_index].midY) < self.stringRect.minY + CGFloat(self.stringRect.height) * 2.0 / 3.0 ) {
                    print("Dot replace: \(_index)")
                    charList[_index] = "·"
                    self.charArray = charList
                    self.content = String(charArray)
                    res = self.content
                }
            }
        }
        
        return res
    }
    
    func FetchTrackingFromDB(_ size: CGFloat) -> (CGFloat, Int16){
        let item = TrackingDataManager.FetchNearestOne(viewContext, fontSize: Int16(size.rounded()))
        //return CGFloat(item.fontTracking)/1000
        //print("item.fontTrackingPoints ",item.fontTrackingPoints)
        //return CGFloat(item.fontTrackingPoints)
        return (CGFloat(item.fontTrackingPoints), item.fontTracking)
    }
    

    mutating func calcColor() {
        
       var img = CIImage.init(contentsOf: URL.init(fileURLWithPath: imagePath))!
        img = img.settingAlphaOne(in: img.extent)
        let newRect = CGRect.init(x: stringRect.minX.rounded(.awayFromZero), y: stringRect.minY.rounded(.awayFromZero), width: stringRect.width.rounded(.towardZero), height: stringRect.height.rounded(.towardZero))
        img = img.cropped(to: newRect)
        img.settingAlphaOne(in: img.extent)

        (color, bgColor) = img.getForegroundBackgroundColor(colorMode: self.colorMode)
    }

//    mutating func CalcColor() -> CGColor {
//
//        var result: CGColor = CGColor.init(red: 1, green: 1, blue: 0, alpha: 1)
//
//        if charImageList.count > 0{
//            if colorMode == .light{
//                var minc = NSColor.init(red: 1, green: 1, blue: 1, alpha: 1)
//                var maxc = NSColor.init(red: 0, green: 0, blue: 0, alpha: 1)
//                var i: Int = 0
//
//                for img in charImageList.filter({$0.extent.width > 0}){
//                    i += 1
//
//                    if Minimun(img).ToGrayScale() <  minc.ToGrayScale()  {
//                        minc = Minimun(img)
//
//                    }
//                    if Maximum(img).ToGrayScale() >  maxc.ToGrayScale()  {
//                        maxc = Maximum(img)
//                    }
//                }
//                bgColor = CGColor.init(red: maxc.redComponent, green: maxc.greenComponent, blue: maxc.blueComponent, alpha: 1)
//                result = CGColor.init(red: minc.redComponent, green: minc.greenComponent, blue: minc.blueComponent, alpha: 1)
//                
//            }
//            
//            else if colorMode == .dark{
//                var minc = NSColor.init(red: 1, green: 1, blue: 1, alpha: 1)
//                var maxc = NSColor.init(red: 0, green: 0, blue: 0, alpha: 1)
//                var i: Int = 0
//                for img in charImageList.filter({$0.extent.width > 0}){
//                    i += 1
//                    //Calculate the brightest color as the font color
//                    if Maximum(img).ToGrayScale() >  maxc.ToGrayScale()  {
//                        maxc = Maximum(img)
//
//                    }
//                    //Calculate the darkest color as the background color
//                    if Minimun(img).ToGrayScale() <  minc.ToGrayScale()  {
//                        minc = Minimun(img)
//                    }
//                }
//                bgColor = CGColor.init(red: minc.redComponent, green: minc.greenComponent, blue: minc.blueComponent, alpha: 1)
//                result = CGColor.init(red: maxc.redComponent, green: maxc.greenComponent, blue: maxc.blueComponent, alpha: 1)
//            }
//        }
////        print(result)
//        color = result
//
//        return result
//    }

    
     func CalcFontFullName() -> String{
        var family = ""
        
        if fontSize/3 < 20 {
//            print("size is \(fontSize), family will be Text")
            family = "Text"
        }else{
//            print("size is \(fontSize), family will be display")
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
        
        let objList = CharDataManager.FetchItems(viewContext, keyValues: keyvalues)
        
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
        
        var res: Int16 = 1
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
            let bw = Filters.shared.SetGrayScale(img)
            let temp = FontWeightPredict.shared.Prediction(ciImage: bw!)
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


