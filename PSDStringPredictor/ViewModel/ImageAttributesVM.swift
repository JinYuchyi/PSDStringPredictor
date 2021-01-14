//
//  ImageAttributesVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import SwiftUI

class ImageVM : PsdsVM {
    @Published var dpi: Int = 0
    @Published var path: String = ""
    @Published var colorMode: String = ""
    @Published var psdId = PsdsUtil.shared.GetSelectedPsdId()
    @Published var imageForShow: NSImage = NSImage.init()
    
    
    
    func FetchInfo(){
        //FetchDpi()
        FetchPath()
        FetchColorModeString()
        //FetchProcessedImage()
    }
    
//    func FetchDpi(){
//        dpi = PsdsUtil.shared.GetDPIForOne(psdId: PsdsUtil.shared.GetSelectedPsdId())
//    }
    
    func FetchPath(){
//        guard let p = DataRepository.shared.GetPsdObject(psdId: DataRepository.shared.GetSelectedPsdId())?.imageURL.path else{
//            return ""
//        }
//        return p
        
        
        path =  psdModel.GetPSDObject(psdId: selectedPsdId)!.imageURL.path ?? "-"
    }
    

    
    func FetchColorModeString(){
//        let cm = PsdsUtil.shared.GetColorMode(psdId:  PsdsUtil.shared.GetSelectedPsdId())
//        if cm == 1{
//            colorMode = "􀆮"
//        }else if cm == 2{
//            colorMode = "􀆺"
//        }else{
//            colorMode = ""
//        }
    }
    
//    func FetchProcessedImage(){
//        imageForShow = PsdsUtil.shared.GetProcessedImage(psdId: PsdsUtil.shared.GetSelectedPsdId()).ToNSImage()
//        //print(imageForShow.size)
//    }
}
