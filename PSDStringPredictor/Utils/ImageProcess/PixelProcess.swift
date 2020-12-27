//
//  PixelProcess.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 25/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import Vision
import SwiftUI

class PixelProcess{
    let ocr = OCR()
    func FixBorder(image img: CIImage, rect: CGRect) -> CGRect {
        
        var x1: Int = Int(rect.minX.rounded())
        //var y1: Int = Int(imageProcessViewModel.GetTargetImageSize()[1].rounded()) - Int(rect.maxY.rounded())
        var y1: Int =  Int(rect.minY.rounded())
        var x2: Int = Int(rect.maxX.rounded())
        var y2: Int = Int(rect.maxY.rounded())
        //var y2: Int = Int(imageProcessViewModel.GetTargetImageSize()[1].rounded()) - Int(rect.minY.rounded())
        var hasDifT: Bool = true
        var hasDifD: Bool = true
        var hasDifL: Bool = true
        var hasDifR: Bool = true
        var previousHasDifT : Bool = true
        var previousHasDifD : Bool = true
        var previousHasDifL : Bool = true
        var previousHasDifR : Bool = true
        var finishT: Bool = false
        var finishD: Bool = false
        var finishL: Bool = false
        var finishR: Bool = false
        var stepT: Int = 6
        var stepD: Int = 6
        var stepL: Int = 6
        var stepR: Int = 6
        
        
        func CheckEdgeT(){
            previousHasDifT = hasDifT
            print("stepT: \(stepT), previousHasDifT: \(previousHasDifT), hasDifT: \(hasDifT)")
            var yTemp = Int(imageProcessViewModel.GetTargetImageSize()[1].rounded()) - y1
            let colorsTop = LoadRangeColors(FromImage: img.ToCGImage()!, Index: yTemp, RangeMin: x1, RangeMax: x2, IsForRow: true)
            hasDifT = HasDifferentColor(ColorArray: colorsTop, Threshhold: 0.1)
            
            if (previousHasDifT == false && hasDifT == true) || stepT == 0 {
                finishT = true
            }
            
            stepT -= 1
            if finishT == false{
                //IsOKT()
                if hasDifT == true  {
                    y1 = y1 - 1
                    yTemp = Int(imageProcessViewModel.GetTargetImageSize()[1].rounded()) - y1
                    let resultRect = CGRect.init(x: x1, y: yTemp, width: abs(x2-x1), height: 1)
                    _ = imageProcessViewModel.targetImageProcessed.cropped(to: resultRect)
                    //tmp.ToPNG(url: URL.init(fileURLWithPath: "/Users/ipdesign/Downloads/untitled folder 3/" + stepT.description + "-" + hasDifT.description  ))
                }else{
                    y1 = y1 + 1
                    yTemp = Int(imageProcessViewModel.GetTargetImageSize()[1].rounded()) - y1
                    let resultRect = CGRect.init(x: x1, y: yTemp, width: abs(x2-x1), height: 1)
                    _ = imageProcessViewModel.targetImageProcessed.cropped(to: resultRect)
                    //tmp.ToPNG(url: URL.init(fileURLWithPath: "/Users/ipdesign/Downloads/untitled folder 3/" + stepT.description + "-" + hasDifT.description))
                }
                CheckEdgeT()
                
            }
        }
        
        func CheckEdgeD(){
            print("CheckEdgeD: previousHasDifD - \(previousHasDifD); hasDifD - \(hasDifD); stepD - \(stepD)")
            previousHasDifD = hasDifD
            let colorsDown = LoadRangeColors(FromImage: img.ToCGImage()!, Index: x2, RangeMin: y1, RangeMax: y2, IsForRow: true)
            hasDifD = HasDifferentColor(ColorArray: colorsDown, Threshhold: 0.1)
            if (previousHasDifD == false && hasDifD == true) || stepD == 0{
                finishD = true
            }
            stepD -= 1
            if finishD == false{
                IsOKD()
            }
        }
        
        func CheckEdgeL(){
            print("CheckEdgeL")
            previousHasDifL = hasDifL
            let colorsLeft = LoadRangeColors(FromImage: img.ToCGImage()!, Index: y1, RangeMin: x1, RangeMax: x2, IsForRow: false)
            hasDifL = HasDifferentColor(ColorArray: colorsLeft, Threshhold: 0.1)
            if (previousHasDifL == false && hasDifL == true) || stepL == 0{
                finishL = true
            }
            stepL -= 1
            if finishL == false{
                IsOKL()
            }
        }
        
        func CheckEdgeR(){
            print("CheckEdgeR")
            previousHasDifR = hasDifR
            let colorsRight = LoadRangeColors(FromImage: img.ToCGImage()!, Index: y2, RangeMin: x1, RangeMax: x2, IsForRow: false)
            hasDifR = HasDifferentColor(ColorArray: colorsRight, Threshhold: 0.1)
            if (previousHasDifR == false && hasDifR == true) || stepR == 0{
                finishR = true
            }
            stepR -= 1
            if finishR == false{
                IsOKR()
            }
        }
        
        //        func CheckEdge(){
        //            let colorsTop = LoadRangeColors(FromImage: img.ToCGImage()!, Index: x1, RangeMin: y1, RangeMax: y2, IsForRow: true)
        //            let colorsDown = LoadRangeColors(FromImage: img.ToCGImage()!, Index: x2, RangeMin: y1, RangeMax: y2, IsForRow: true)
        //            let colorsLeft = LoadRangeColors(FromImage: img.ToCGImage()!, Index: y1, RangeMin: x1, RangeMax: x2, IsForRow: false)
        //            let colorsRight = LoadRangeColors(FromImage: img.ToCGImage()!, Index: y2, RangeMin: x1, RangeMax: x2, IsForRow: false)
        //
        //            let hasDifT = HasDifferentColor(ColorArray: colorsTop, Threshhold: 0.1)
        //            let hasDifD = HasDifferentColor(ColorArray: colorsDown, Threshhold: 0.1)
        //            let hasDifL = HasDifferentColor(ColorArray: colorsLeft, Threshhold: 0.1)
        //            let hasDifR = HasDifferentColor(ColorArray: colorsRight, Threshhold: 0.1)
        //        }
        func IsOKT(){
            if hasDifT == true  {
                x1 = x1 - 1
                CheckEdgeT()
            }else{
                x1 = x1 + 1
                CheckEdgeT()
            }
            
        }
        
        func IsOKD(){
            if hasDifD == true  {
                x2 = x2 + 1
                CheckEdgeD()
            }else{
                x2 = x2 - 1
                CheckEdgeD()
            }
        }
        
        func IsOKL(){
            if hasDifL == true  {
                y1 = y1 - 1
                CheckEdgeL()
            }else{
                y1 = y1 + 1
                CheckEdgeL()
            }
            
        }
        
        func IsOKR(){
            if hasDifR == true  {
                y2 = y2 + 1
                CheckEdgeR()
            }else{
                y2 = y2 - 1
                CheckEdgeR()
            }
            
        }
        
        CheckEdgeT()
        //        CheckEdgeD()
        //        CheckEdgeL()
        //        CheckEdgeR()
        
        
        //        if (finishT == true && finishD == true && finishL == true && finishR == true){
        //            //Return rect
        //        }
        //Return rect
        let resultRect = CGRect.init(x: x1, y: y1, width: x2-x1, height: y2-y1)
        
        //        print("Original rect: \(rect)")
        //        print("Fixed rect: \(resultRect)")
        //        print("\(stepT), \(stepD)")
        
        return resultRect
    }
    
    func LoadALineColors(FromImage img: CGImage, Index index : Int, IsForRow forRow: Bool) -> [NSColor] {
        var colors: [NSColor] = []
        if (forRow == true){
            for w in 0 ..< img.width {
                let tmp = colorAt(x: w, y: index, img: img)
                colors.append(tmp)
            }
        }
        else{
            for h in 0 ..< img.height {
                let tmp = colorAt(x: index, y: h, img: img)
                colors.append(tmp)
            }
        }
        return colors
    }
    
    func LoadRangeColors(FromImage img: CGImage, Index index : Int, RangeMin min: Int, RangeMax max: Int, IsForRow forRow: Bool) -> [NSColor] {
        var colors: [NSColor] = []
        
        if (forRow == true){
            //var index = Int(imageProcessViewModel.GetTargetImageSize()[1].rounded()) - index
            for w in min...max {
                let tmp = colorAt(x: w, y: index, img: img)
                colors.append(tmp)
            }
        }
        else{
            for h in min...max {
                //let hFix = Int(imageProcessViewModel.GetTargetImageSize()[1].rounded()) - h
                let tmp = colorAt(x: index, y: h, img: img)
                colors.append(tmp)
            }
        }
        print("Row: \(index), range: \(min) - \(max)")
        for c in colors{
            print(c)
        }
        
        return colors
    }
    
    func HasDifferentColor(ColorArray colors: [NSColor], Threshhold threshold: CGFloat) -> Bool {
        var minBrightness: CGFloat = 1
        var maxBrightness: CGFloat = 0
        
        for c in colors {
            if (c.ToGrayScale() < minBrightness) {
                minBrightness = c.ToGrayScale()
            }
            if (c.ToGrayScale() > maxBrightness) {
                maxBrightness = c.ToGrayScale()
            }
        }
        
        if (maxBrightness - minBrightness > threshold){
            //            print("True dif:")
            //            print("Max: \(maxBrightness), min:\(minBrightness),\(maxBrightness - minBrightness)")
            return true
        }
        else{
            //print("False dif:")
            
            //print("Max: \(maxBrightness), min:\(minBrightness),\(maxBrightness - minBrightness)")
            return false
        }
    }
    
    func colorAt(x: Int, y: Int, img: CGImage)->NSColor {
        
        let context = self.createBitmapContext(img: img)
        var color: NSColor = NSColor.init(red: 1, green: 1, blue: 1, alpha: 1)

//        assert(0<=x && x < context.width)
//        assert(0<=y && y < context.height)
        if (x < 0 || x >= context.width || y < 0 || y >= context.height){
            return color
        }
        
        guard let pixelBuffer = context.data else { return color }
        let data = pixelBuffer.bindMemory(to: UInt8.self, capacity: context.width * context.height)
        
        let offset = 4 * (y * context.width + x)
        let alpha: UInt8 = data[offset]
        let red: UInt8 = data[offset+1]
        let green: UInt8 = data[offset+2]
        let blue: UInt8 = data[offset+3]
        
        color = NSColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
        
        return color
    }
    
    func createBitmapContext(img: CGImage) -> CGContext {
        
        // Get image width, height
        let pixelsWide = img.width
        let pixelsHigh = img.height
        
        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        _ = CGSize(width: CGFloat(pixelsWide), height: CGFloat(pixelsHigh))
        //CGBitmapContextCreate
        //UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // create bitmap
        let context = CGContext(data: bitmapData,
                                width: pixelsWide,
                                height: pixelsHigh,
                                bitsPerComponent: 8,
                                bytesPerRow: bitmapBytesPerRow,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        
        // draw the image onto the context
        let rect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)
        
        context?.draw(img, in: rect)
        
        return context!
    }
    
    
    
    
}
