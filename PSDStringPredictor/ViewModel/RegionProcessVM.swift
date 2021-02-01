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
//    @Published var regionOverlay: CIImage = CIImage.init()
    @Published var regionImageForProcess: CIImage = CIImage.init()
    @Published var regionActive: Bool = false
//    @Published var targetImageWidth: CGFloat = 0
//    @Published var targetImageHeight: CGFloat = 0
    
    var targetImage: CIImage = CIImage.init()
    
    let imgUtil = ImageUtil()
    
    private func fetchRegionOverlay( regionRect: CGRect, bgWidth: CGFloat, bgHeight: CGFloat) -> (mask1: CIImage, mask2: CIImage){
        let bgImg = CIImage.init(color: CIColor.black ).cropped(to: CGRect.init(x: 0, y: 0, width: bgWidth, height: bgHeight))
        let regionImg = CIImage.init(color: CIColor.init(red: 1, green: 1, blue: 1, alpha: 1)).cropped(to: CGRect.init(x: 0, y: 0, width: regionRect.width, height: regionRect.height))
        let mask1 = imgUtil.ImageOntop(OverlayImage: regionImg, BGImage: bgImg, OffsetX: regionRect.minX, OffsetY: regionRect.minY)
        
        let bgImg2 = CIImage.init(color: CIColor.white ).cropped(to: CGRect.init(x: 0, y: 0, width: bgWidth, height: bgHeight))
        let regionImg2 = CIImage.init(color: CIColor.black).cropped(to: CGRect.init(x: 0, y: 0, width: regionRect.width, height: regionRect.height))
        let mask2 = imgUtil.ImageOntop(OverlayImage: regionImg2, BGImage: bgImg2, OffsetX: regionRect.minX, OffsetY: regionRect.minY)
        
        return (mask1, mask2)
//        let tmpPath = GetDocumentsPath().appending("/test1.bmp")
//        regionImg.ToPNG(url: URL.init(fileURLWithPath: tmpPath))
    }
    
    func fetchOverlayedImage(regionRect: CGRect, targetImage: CIImage, pixColor: CIColor)->CIImage{
        var ( maskImg01,  maskImg02) = fetchRegionOverlay(regionRect: regionRect, bgWidth: targetImage.extent.width, bgHeight: targetImage.extent.height)
        let img1 = Multiply(bgImage: targetImage, maskImage: maskImg01)
        let bgImg = CIImage.init(color: pixColor ).cropped(to: CGRect.init(x: 0, y: 0, width: targetImage.extent.width, height: targetImage.extent.height))
        let img2 = Multiply(bgImage: bgImg, maskImage: maskImg02)
        return Multiply(bgImage: targetImage, maskImage: regionOverlay) ?? targetImage
    }
    
    //Intent
    func regionBtnPressed() {
//        FetchTargetImageInfo()
        regionActive.toggle()
    }
    
//    func FetchTargetImageInfo(){
//        let psdVM = PsdsVM()
//        print("In fetch: \(psdVM.selectedNSImage.size.width)")
//
//        if psdVM.selectedNSImage.size.width > 0{
//            targetImageWidth = psdVM.selectedNSImage.size.width
//            targetImageHeight = psdVM.selectedNSImage.size.height
//            targetImage = psdVM.selectedNSImage.ToCIImage()!
//        }
//    }
    
}
