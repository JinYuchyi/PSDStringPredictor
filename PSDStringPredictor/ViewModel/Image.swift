//
//  Image.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 21/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import Cocoa

class ImageViewModel: ObservableObject{
    //var data: DataStore
    
    @Published var targetImageProcessed = CIImage.init()
    @Published var targetNSImage = NSImage.init()
    //@Published var targetImageSize: [CGFloat] = []
    
//    init(){
//        UpdateTargetImageInfo()
//    }
    
//    func UpdateTargetImageInfo(){
//        self.targetNSImage = DataStore.targetNSImage
//        self.targetCIImage = targetNSImage.ToCIImage()!
//        self.targetImageSize = [targetNSImage.size.width, targetNSImage.size.height]
//    }
    
    func FetchNSImage(){
        //UpdateTargetImageInfo()
        targetNSImage = DataStore.targetNSImage
        //return targetNSImage
    }
    
    func FetchCIImage() -> CIImage{
        targetNSImage = DataStore.targetNSImage
        //UpdateTargetImageInfo()
        return targetNSImage.ToCIImage()!
    }
    
    func GetTargetImageSize() -> [CGFloat]{
        return [targetNSImage.size.width, targetNSImage.size.height]
    }
    
    
//
}
