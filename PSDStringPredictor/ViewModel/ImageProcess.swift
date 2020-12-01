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
   
//    @Published var targetImage: CIImage  = CIImage.init()
//    @Published var targetImageName: String = "default_image"
//    @Published var targetImageSize: [Int64] = []
    //@EnvironmentObject var data: DataStore
    let colorModeClassifier = ColorModeClassifier()
    var strObjVM = stringObjectViewModel
    //var stringObject: StringObject = StringObject()
    @Published var targetImageProcessed = CIImage.init()
    @Published var targetNSImage = NSImage()
    @Published var targetCIImage = CIImage()
    
    var showImage: Bool = false

    func FetchImage() {
        targetNSImage = DataStore.targetNSImage
        targetCIImage = targetNSImage.ToCIImage()!
        targetImageProcessed = DataStore.targetImageProcessed
    }
    
     func GetTargetCIImage() -> CIImage{
        //UpdateTargetImageInfo()
        return targetCIImage
    }
    
     func GetProcessedImage() -> CIImage{
//        if DataStore.targetImageProcessed.extent.width > 0 {
//        }
//        else{
//            DataStore.targetImageProcessed = DataStore.targetNSImage.ToCIImage()!
//        }
        return targetImageProcessed
    }
    
     func GetProcessedNSImage() -> NSImage{
        if DataStore.targetImageProcessed.extent.width > 0 {
            //return targetImageProcessed = DataStore.targetImageProcessed
        }
        else{
            DataStore.targetImageProcessed = DataStore.targetNSImage.ToCIImage()!
            //targetImageProcessed = DataStore.targetNSImage.ToCIImage()!
        }
        return DataStore.targetImageProcessed.ToNSImage()
    }
    
    func GetTargetImageSize() -> [CGFloat]{
        return [DataStore.targetNSImage.size.width, DataStore.targetNSImage.size.height]
    }
    
    func SetTargetNSImage(_ img: NSImage){
        DataStore.targetNSImage = img
        DataStore.targetImageProcessed = DataStore.targetNSImage.ToCIImage()!
        if(DataStore.targetImageProcessed.extent.width > 0){}
        else{
            DataStore.targetImageProcessed = DataStore.targetNSImage.ToCIImage()!
        }
        FetchImage()
    }
    
    func SetTargetProcessedImage(_ img: CIImage) {
        DataStore.targetImageProcessed = img
        FetchImage()
    }
    
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
    
//    func GetTargetImageSize() -> [Int]{
//        let img : CGImage = ImageStore.loadImage(name: targetImageName)
//        return [img.width, img.height]
//    }

    func LoadCIImage(FileName: String) -> CIImage?{
       let fileURL = Bundle.main.url(forResource: FileName, withExtension: "png")

        let img = CIImage(contentsOf: fileURL!)
        return img
    }
    
    func ConvertCGImageToCIImage(inputImage: CGImage) -> CIImage! {
        let ciImage = CIImage(cgImage: inputImage)
        return ciImage
    }
    
    func SaveCIIToPNG(CIImage img: CIImage, filePath path: String){
        let url = URL(fileURLWithPath: path)
        img.ToPNG(url: url)
    }
    
    func LoadImageBtnPressed()  {
        let panel = NSOpenPanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                if ((panel.url?.pathExtension == "png" || panel.url?.pathExtension == "PNG" || panel.url?.pathExtension == "psd" || panel.url?.pathExtension == "PSD") )
                {
                    //Reset stringobject list
                    self.strObjVM.stringObjectListData.removeAll()
                    DataStore.charFrameList.removeAll()
                    let tmp = LoadNSImage(imageUrlPath: panel.url!.path)
                    self.SetTargetNSImage(tmp)
                    self.showImage = true
                    
                    self.colorModeClassifier.Prediction(fromImage: DataStore.targetImageProcessed)
                    imagePropertyViewModel.SetImageColorMode(modeIndex: DataStore.colorMode)
                    DataStore.imagePath = panel.url!.path
                }
            }
        }
        
    }

    
}

func LoadNSImage(imageUrlPath: String) -> NSImage {
    var  newImg :NSImage = NSImage.init()
    if FileManager.default.fileExists(atPath: imageUrlPath) {
        let url = URL.init(fileURLWithPath: imageUrlPath)

        let data = NSData(contentsOf: url)!
        newImg = NSImage(data: data as Data)!
        //print(newImg.isValid)
    }
    return newImg
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
    //print("Change gamma value: \(value)")
    let filter = CIFilter(name: "CIGammaAdjust")
    //let ciImage = CIImage(image: #imageLiteral(resourceName: "image"))
    filter?.setValue(image, forKey: kCIInputImageKey)
    filter?.setValue(value, forKey: "inputPower")
    let filteredImage = filter?.outputImage
    return filteredImage
}

func ChangeExposure(_ image: CIImage, _ value: CGFloat = 0.5)-> CIImage?{
    let filter = CIFilter(name: "CIExposureAdjust")
    //let ciImage = CIImage(image: #imageLiteral(resourceName: "image"))
    filter?.setValue(image, forKey: kCIInputImageKey)
    filter?.setValue(value, forKey: "inputEV")
    let filteredImage = filter?.outputImage
    return filteredImage
}

func SetConv(_ image: CIImage)-> CIImage?{
    let weights:[CGFloat] = [0,-1,0,-1,4,-1,0,-1,0]
    let filter = CIFilter(name: "CIConvolution3X3")
    //let ciImage = CIImage(image: #imageLiteral(resourceName: "image"))
    filter?.setValue(image, forKey: "inputImage")
    filter?.setValue(CIVector(string:"[0 -2 0 -2 9 -2 0 -2 0]"), forKey: "inputWeights")
    filter?.setValue(0.00, forKey: "inputBias")
    let filteredImage = filter?.outputImage
    return filteredImage
}

func SetGrayScale(_ image: CIImage) -> CIImage?{
    let filter = CIFilter(name: "CIPhotoEffectNoir")
    filter?.setValue(image, forKey: kCIInputImageKey)
    let filteredImage = filter?.outputImage
    return filteredImage
}

func Maximum(_ image: CIImage) -> NSColor{
    let pixelProcess = PixelProcess()

    let filter = CIFilter(name: "CIAreaMaximum")
    filter?.setValue(image, forKey: "inputImage")
    filter?.setValue(image.extent, forKey: "inputExtent")
    let filteredImage = filter?.outputImage
    let c = pixelProcess.colorAt(x: 0, y: 0, img: filteredImage!.ToCGImage()!)
    //filteredImage?.ToPNG(url: URL(fileURLWithPath: "/Users/ipdesign/Downloads/pix_max.png"))
    
    return c
}

func Minimun(_ image: CIImage) -> NSColor{
    let pixelProcess = PixelProcess()

    let filter = CIFilter(name: "CIAreaMinimum")
    filter?.setValue(image, forKey: "inputImage")
    filter?.setValue(image.extent, forKey: "inputExtent")
    let filteredImage = filter?.outputImage
    
    //filteredImage?.ToPNG(url: URL(fileURLWithPath: "/Users/ipdesign/Downloads/pix_min.png"))
    let img = filteredImage!.ToCGImage()
    let size = filteredImage!.extent
    let c = pixelProcess.colorAt(x: 0, y: 0, img: img!)
    //img?.ToCIImage().ToPNG(url: URL(fileURLWithPath: "/Users/ipdesign/Downloads/test/\(c.redComponent)-\(c.greenComponent)-\(c.blueComponent)"))
    //print("Test: \(c.blueComponent)")
    return c
}

func NoiseReduction(_ image: CIImage) -> CIImage?{
    //let pixelProcess = PixelProcess()

    let filter = CIFilter(name: "CINoiseReduction")
    filter?.setValue(0.3, forKey: "inputSharpness")
    filter?.setValue(0.1, forKey: "inputNoiseLevel")
    filter?.setValue(image, forKey: "inputImage")
    let filteredImage = filter?.outputImage
    
    return filteredImage
}

//Default is 0.4
func ChangeSharpen(_ image: CIImage, _ value: CGFloat = 0.4)-> CIImage?{
    let filter = CIFilter(name: "CISharpenLuminance")
    //let ciImage = CIImage(image: #imageLiteral(resourceName: "image"))
    filter?.setValue(image, forKey: kCIInputImageKey)
    filter?.setValue(value, forKey: "inputSharpness")
    let filteredImage = filter?.outputImage
    return filteredImage
}

//func CompareImages(img1: CIImage, img2: CIImage) -> CIImage {
//    if CIIExist(img: img1) && CIIExist(img: img2) == true{
//        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
//        let request = VNGenerateImageFeaturePrintRequest()
//        do {
//            try requestHandler.perform([request])
//            let result = request.results?.first as? VNFeaturePrintObservation
//            var distance = Float(0)
//            try result?.computeDistance(&distance, to: sourceResult)
//        }catch{
//        }
//    }
//    else{
//        return CIImage.init()
//    }
//    
//}

func CIIExist(img: CIImage) -> Bool {
    if img.extent.width > 0 {
        return true
    }
    else {return false}
}

func getAllFilePath(_ dirPath: String) -> [String]? {
    var filePaths = [String]()
    
    do {
        let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
        
        for fileName in array {
            var isDir: ObjCBool = true
            
            let fullPath = "\(dirPath)/\(fileName)"
            
            if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                if !isDir.boolValue {
                    filePaths.append(fullPath)
                }
            }
        }
        
    } catch let error as NSError {
        print("get file path error: \(error)")
    }
    
    return filePaths
}



