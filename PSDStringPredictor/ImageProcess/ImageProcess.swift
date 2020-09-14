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

class ImageProcess{
//    @Published var targetImage: CIImage  = CIImage.init()
//    @Published var targetImageName: String = "default_image"
//    @Published var targetImageSize: [Int64] = []
    @EnvironmentObject var data: DataStore
    
    func convertCGImageToCIImage(inputImage: CGImage) -> CIImage! {
        let ciImage = CIImage(cgImage: inputImage)
        return ciImage
    }

    //name: only the file name, path string and "png" do not included.
    func GetImage(name: String) -> Image{
        var image: Image {
            ImageStore.shared.image(name: name)
        }
        
        return image
    }
    
    func GetTargetImageSize() -> [Int]{
        let img : CGImage = ImageStore.loadImage(name: data.targetImageName)
        return [img.width, img.height]
    }

    func LoadCIImage(FileName: String) -> CIImage?{
       let fileURL = Bundle.main.url(forResource: FileName, withExtension: "png")

        let img = CIImage(contentsOf: fileURL!)
        return img
    }
    
    func ConvertCGImageToCIImage(inputImage: CGImage) -> CIImage! {
        let ciImage = CIImage(cgImage: inputImage)
        return ciImage
    }

}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 1
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(name))
    }

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "png"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).png from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

func ChangeGamma(_ image: CIImage, _ value: CGFloat) -> CIImage? {
    print("Change gamma value: \(value)")
    
    let filter = CIFilter(name: "CIGammaAdjust")
    //let ciImage = CIImage(image: #imageLiteral(resourceName: "image"))
    filter?.setValue(image, forKey: kCIInputImageKey)
    filter?.setValue(value, forKey: "inputPower")
    let filteredImage = filter?.outputImage
    return filteredImage
}

