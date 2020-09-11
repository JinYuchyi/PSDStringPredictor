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

class ImageProcess{
    
    func convertCGImageToCIImage(inputImage: CGImage) -> CIImage! {
        var ciImage = CIImage(cgImage: inputImage)
        return ciImage
    }
    
//    func GetCIImage(PathFrom path: String){
//        let url = URL(string: path)
//        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        imageView.image = UIImage(data: data!)
//    }
}

