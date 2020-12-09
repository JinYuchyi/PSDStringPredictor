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
    

}
