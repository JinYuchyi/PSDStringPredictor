//
//  RegionProcessVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 29/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import CoreImage

class RegionProcessVM: ObservableObject {

    //@Published var regionRect: CGRect = CGRect.init()
    @Published var regionOverlay: CIImage = CIImage.init()
    @Published var regionImageForProcess: CIImage = CIImage.init()
    @Published var regionActive: Bool = false
    
    let imgUtil = ImageUtil()
    
    private func fetchRegionOverlay(totalWidth: CGFloat, totalHeight: CGFloat,  regionRect: CGRect){
        var bgImg = CIImage.init(color: CIColor.white).cropped(to: CGRect.init(x: 0, y: 0, width: totalWidth, height: totalHeight))
        var regionImg = CIImage.init(color: CIColor.white).cropped(to: regionRect)
        regionOverlay = imgUtil.ImageOntop(OverlayImage: regionImg, BGImage: bgImg)
    }
    
    private func fetchOverlayedImage(fromImage: CIImage, regionRect: CGRect){
        fetchRegionOverlay(totalWidth: fromImage.extent.width, totalHeight: fromImage.extent.height, regionRect: regionRect)
        regionImageForProcess = imgUtil.ImageOntop(OverlayImage: regionOverlay, BGImage: fromImage)
    }
    
    //Intent
    func regionBtnPressed() {
        regionActive.toggle()
    }
    

}
