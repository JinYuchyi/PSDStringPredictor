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
    
}
