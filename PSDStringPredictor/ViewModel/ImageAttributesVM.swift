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

class ImageVM : ObservableObject {
    @Published var dpi: Int = 0
    @Published var path: String = ""
    @Published var colorMode: String = ""
    @Published var psdId = DataRepository.shared.GetSelectedPsdId()
    @Published var imageForShow: NSImage = NSImage.init()
    
    
    
    func FetchInfo(){
        FetchDpi()
        FetchPath()
        FetchColorModeString()
        FetchProcessedImage()
    }
    
    func FetchDpi(){
        dpi = DataRepository.shared.GetDPIForOne(psdId: DataRepository.shared.GetSelectedPsdId())
    }
    
    func FetchPath(){
//        guard let p = DataRepository.shared.GetPsdObject(psdId: DataRepository.shared.GetSelectedPsdId())?.imageURL.path else{
//            return ""
//        }
//        return p
        path =  DataRepository.shared.GetPsdObject(psdId: DataRepository.shared.GetSelectedPsdId())!.imageURL.path ?? "-"
    }
    
    func FetchColorModeString(){
        let cm = DataRepository.shared.GetColorMode(psdId:  DataRepository.shared.GetSelectedPsdId())
        if cm == 1{
            colorMode = "􀆮"
        }else if cm == 2{
            colorMode = "􀆺"
        }else{
            colorMode = ""
        }
    }
    
    func FetchProcessedImage(){
        imageForShow = DataRepository.shared.GetProcessedImage(psdId: DataRepository.shared.GetSelectedPsdId()).ToNSImage()
        //print(imageForShow.size)
    }
}
