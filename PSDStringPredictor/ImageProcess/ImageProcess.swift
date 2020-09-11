//
//  ImageProcess.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 10/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import Vision
import SwiftUI

class ImageProcess: ObservableObject{
    @Published var targetImagePath: CIImage  = LoadCIImage("/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/default_image.png")
    
    func convertCGImageToCIImage(inputImage: CGImage) -> CIImage! {
        var ciImage = CIImage(cgImage: inputImage)
        return ciImage
    }


    //name: only the file name, path string and "png" do not included.
    func GetImage(name: String) -> Image{
        var image: Image {
            ImageStore.shared.image(name: name)
        }
        
        return image
    }

    func LoadCIImage(path: String) -> CIImage{
        var img = CIImage(contentsOf: URL(fileURLWithPath: path))
        return img!
    }

}
