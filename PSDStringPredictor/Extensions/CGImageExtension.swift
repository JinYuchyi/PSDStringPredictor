//
//  CGImageExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 23/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
extension CGImage{
    func ToCIImage() -> CIImage{
        return CIImage.init(cgImage: self)
    }
    
    func colorAt(point: CGPoint) -> (CGFloat, CGFloat, CGFloat, CGFloat){
        let pixelData=self.dataProvider!.data
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.width) * Int(point.y)) + Int(point.x)) * 4
        let r = CGFloat(data[pixelInfo])
        let g = CGFloat(data[pixelInfo+1])
        let b = CGFloat(data[pixelInfo+2])
        let a = CGFloat(data[pixelInfo+3])
        return (r,g,b,1)
    }
    
    func maxMinColor() -> (min: [CGFloat], max: [CGFloat]){
//        print("alpha: \(self.alphaInfo.rawValue)")
//        var ci = self.ToCIImage()
//        ci.settingAlphaOne(in: ci.extent)
//        let _data = self.bitsPerPixel
//        ci = ci.premultiplyingAlpha()
//        ci.ToPNG(url: URL.init(fileURLWithPath: "/Users/ipdesign/Downloads/123.png"))
        let pixelData=self.dataProvider!.data
//        print(ci.ToCGImage().dataProvider!.info.debugDescription)
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
//        let pixelInfo: Int = ((Int(self.width) * Int(point.y)) + Int(point.x)) * 4
//        let r = CGFloat(data[pixelInfo])
//        let g = CGFloat(data[pixelInfo+1])
//        let b = CGFloat(data[pixelInfo+2])
//        let a = CGFloat(data[pixelInfo+3])
        
//        var i: Int
//        var j: Int
        var maxB: CGFloat = 0
        var minB: CGFloat = 1000
        var max: [CGFloat] = []
        var min: [CGFloat] = []

        for j in 0..<(self.height) {
            for i in 0..<(self.width){
                let pixelInfo: Int = ((self.width * j) + i) * 4
                if CGFloat(data[pixelInfo]) + CGFloat(data[pixelInfo + 1]) + CGFloat(data[pixelInfo + 2]) != 0{
                    let l = (0.21 * CGFloat(data[pixelInfo])) + (0.72 * CGFloat(data[pixelInfo + 1])) + (0.07 * CGFloat(data[pixelInfo + 2]))
                    if l > maxB {
                        maxB = l
                        max = [CGFloat(data[pixelInfo])/255, CGFloat(data[pixelInfo+1])/255, CGFloat(data[pixelInfo+2])/255]
                    }
                    if l < minB {
                        minB = l
                        min = [CGFloat(data[pixelInfo])/255, CGFloat(data[pixelInfo+1])/255, CGFloat(data[pixelInfo+2])/255]
                    }
                }

            }
        }

        return (min, max)
    }
    
}
