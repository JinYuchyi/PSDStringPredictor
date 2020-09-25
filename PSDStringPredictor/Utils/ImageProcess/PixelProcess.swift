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
            return true
        }
        else{
            return false
        }
    }
    
    func colorAt(x: Int, y: Int, img: CGImage)->NSColor {
        
        let context = self.createBitmapContext(img: img)

        assert(0<=x && x < context.width)
        assert(0<=y && y < context.height)
        

        guard let pixelBuffer = context.data else { return .white }
        let data = pixelBuffer.bindMemory(to: UInt8.self, capacity: context.width * context.height)

        let offset = 4 * (y * context.width + x)

        let alpha: UInt8 = data[offset]
        let red: UInt8 = data[offset+1]
        let green: UInt8 = data[offset+2]
        let blue: UInt8 = data[offset+3]

        let color = NSColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)

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
        let size = CGSize(width: CGFloat(pixelsWide), height: CGFloat(pixelsHigh))
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
