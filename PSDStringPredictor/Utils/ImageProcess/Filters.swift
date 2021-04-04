//
//  Filters.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 4/4/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import Vision

class Filters {
    static let shared = Filters.init()
    
    private init(){}
    
    func FilterLanczosScaleTransform(image: CIImage, size: CGFloat)-> CIImage? {
        var scale: CGFloat = 1
        image.extent.width > image.extent.height ? (scale = image.extent.width / size) : (scale = image.extent.height / size)
        let filter = CIFilter(name: "CILanczosScaleTransform")
        filter?.setValue(image, forKey: "inputImage")
        filter?.setValue(scale, forKey: "inputScale")
        filter?.setValue(1, forKey: "inputAspectRatio")
        let filteredImage = filter?.outputImage
        return filteredImage
    }

    func SourceOverCompositing(inputImage: CIImage, inputBackgroundImage: CIImage) -> CIImage?{
        let filter = CIFilter(name: "CISourceOverCompositing")
        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(inputBackgroundImage, forKey: "inputBackgroundImage")
        let filteredImage = filter?.outputImage
        return filteredImage
    }

    func Multiply(bgImage: CIImage, maskImage: CIImage)-> CIImage? {
        let filter = CIFilter(name: "CIMultiplyBlendMode")
        filter?.setValue(maskImage, forKey: "inputImage")
        filter?.setValue(bgImage, forKey: "inputBackgroundImage")
        let filteredImage = filter?.outputImage
        return filteredImage
    }

    func ChangeGamma(_ image: CIImage, _ value: CGFloat) -> CIImage? {
        var filter = CIFilter(name: "CIGammaAdjust")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(value, forKey: "inputPower")
        let filteredImage = filter?.outputImage
        filter = nil
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
        //let weights:[CGFloat] = [0,-1,0,-1,4,-1,0,-1,0]
        let filter = CIFilter(name: "CIConvolution3X3")
        //let ciImage = CIImage(image: #imageLiteral(resourceName: "image"))
        filter?.setValue(image, forKey: "inputImage")
        filter?.setValue(CIVector(string:"[0 -2 0 -2 9 -2 0 -2 0]"), forKey: "inputWeights")
        filter?.setValue(0.00, forKey: "inputBias")
        let filteredImage = filter?.outputImage
        return filteredImage
    }

    func SetGrayScale(_ image: CIImage) -> CIImage?{
        var filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(image, forKey: kCIInputImageKey)
        let filteredImage = filter?.outputImage
        filter = nil
        
        return filteredImage
    }

    //func Maximum(_ image: CIImage) -> (NSColor){
    ////    let pixelProcess = PixelProcess()
    //    //let colorSpace: NSColorSpace = .genericRGB
    //    var color: NSColor = NSColor.init(red: 1, green: 0, blue: 1, alpha: 1)
    //    var filteredImage = DataStore.zeroCIImage
    //    let filter = CIFilter(name: "CIAreaMaximum")
    //    filter?.setValue(image, forKey: "inputImage")
    //    filter?.setValue(image.extent.ToCIVector(), forKey: "inputExtent")
    //    filteredImage = filter?.outputImage ?? DataStore.zeroCIImage
    //    if filteredImage.IsValid() == true{
    //        color = PixelProcess.shared.colorAt(x: 0, y: 0, img: filteredImage.ToCGImage()!)
    //
    //    }else {
    //
    //    }
    //    return (color)
    //}

    func Maximum(_ image: CIImage) -> ([CGFloat]){
    //    var img = image.unpremultiplyingAlpha()
        var img = image.settingAlphaOne(in: image.extent)
        

        var filteredImage: CIImage = CIImage.init()
    //    filteredImage.unpremultiplyingAlpha()

        var colorValueList: [CGFloat] =  [255,0,0]

    //    img.unpremultiplyingAlpha()

        if img.extent.width > 0 {
            guard let filter = CIFilter(name: "CIAreaMaximum") else {
                return (colorValueList)
            }
            filter.setValue(img, forKey: kCIInputImageKey)
            filter.setValue(img.extent.ToCIVector(), forKey: kCIInputExtentKey)
            filteredImage = filter.outputImage ?? DataStore.zeroCIImage
            filteredImage = filteredImage.settingAlphaOne(in: filteredImage.extent)
//            var path = "/Users/ipdesign/Downloads/max.png"
//            filteredImage.ToPNG(url: URL.init(fileURLWithPath: path))
            
            if filteredImage.IsValid() == true{
                colorValueList = PixelProcess.shared.colorAt(x: 0, y: 0, img: filteredImage)
                return (colorValueList)
            }
        }
        return (colorValueList)
    }

    func Minimun(_ image: CIImage) -> ([CGFloat]){
    //    var img = image.unpremultiplyingAlpha()
        var img = image.settingAlphaOne(in: image.extent)

    //    image.ToPNG(url: URL.init(fileURLWithPath: path))
        var filteredImage: CIImage = CIImage.init()

        var colorValueList: [CGFloat] =  [255,0,0]


        if img.extent.width > 0 {
            guard let filter = CIFilter(name: "CIAreaMinimum") else {
                return (colorValueList)
            }
            
            filter.setValue(img, forKey: kCIInputImageKey)
            filter.setValue(img.extent.ToCIVector(), forKey: kCIInputExtentKey)
            filteredImage = filter.outputImage ?? DataStore.zeroCIImage //Result Correct
            filteredImage = filteredImage.settingAlphaOne(in: filteredImage.extent)
    //        filteredImage = filteredImage.unpremultiplyingAlpha()

//            var path = "/Users/ipdesign/Downloads/Minimum.png"
//            filteredImage.ToPNG(url: URL.init(fileURLWithPath: path))
            if filteredImage.IsValid() == true{
                colorValueList = PixelProcess.shared.colorAt(x: 0, y: 0, img: filteredImage)
                return (colorValueList)
            }
        }
        return (colorValueList)
    }

    func filterThreshold(img: CIImage, value: CGFloat) -> CIImage{
        var filteredImage: CIImage = CIImage.init()
        if img.extent.width > 0 {
            guard let filter = CIFilter(name: "CIColorThreshold") else {
                return (filteredImage)
            }
            filter.setValue(img, forKey: kCIInputImageKey)
            let val = NSNumber.init(value: Float(value))
            filter.setValue(val, forKey: "inputThreshold")
            filteredImage = filter.outputImage ?? DataStore.zeroCIImage
        }
        return (filteredImage)
    }

    func MaxMinTemp(img: CIImage) -> (min: [CGFloat], max: [CGFloat]) {
        var newImg = img.settingAlphaOne(in: img.extent)
        if newImg.IsValid() {
            let minmax = newImg.ToCGImage()?.maxMinColor()
            
    //        var bitmap = [UInt8](repeating: 0, count: 8)
    //        context.render(img, toBitmap: &bitmap, rowBytes: 8, bounds: CGRect(x: 0, y: 0, width: 2, height: 1), format: .RGBA8, colorSpace: nil)
    //        let min = [CGFloat(bitmap[0])/255, CGFloat(bitmap[1])/255, CGFloat(bitmap[2])/255]
    //        let max = [CGFloat(bitmap[4])/255, CGFloat(bitmap[5])/255, CGFloat(bitmap[6])/255]
            return (minmax!.min, minmax!.max)
        }else {
            return ([],[])
        }
    }

    func MaxMin(img: CIImage = CIImage.init() ) -> (min: [CGFloat], max: [CGFloat]) {
        var new = CIImage.init(contentsOf: URL.init(fileURLWithPath: "/Users/ipdesign/Downloads/test.png"))!
        new = new.settingAlphaOne(in: new.extent)
    //    print("min:\(Maximum(new)), max:\(Minimun(new))")
        

        
        
    //    var new = img.unpremultiplyingAlpha()
    //    Minimun(img)
    //    var new = img.settingAlphaOne(in: img.extent)
    //    areaHistogram(img: new)
    //    new.matchedFromWorkingSpace(to: CGColorSpace.init(name: CGColorSpace.extendedLinearDisplayP3)!)!
        var filteredImage: CIImage = CIImage.init()
    //    filteredImage  = filteredImage.settingAlphaOne(in: filteredImage.extent)
        var min: [CGFloat] = [1,0,0]
        var max: [CGFloat] = [1,0,0]
//        var path = "/Users/ipdesign/Downloads/row.png"
//        img.ToPNG(url: URL.init(fileURLWithPath: path))
    //    areaHistogram(img: img)
        guard let filter = CIFilter(name: "CIAreaMinMax") else {
            
            return (min,max)
        }

        filter.setValue(new, forKey: kCIInputImageKey)
        filter.setValue(new.extent.ToCIVector(), forKey: kCIInputExtentKey)
        
        filteredImage = filter.outputImage ?? DataStore.zeroCIImage
    //    let context = CIContext(options: [.workingColorSpace: kCFNull])
    //    filteredImage = filteredImage.matchedFromWorkingSpace(to: CGColorSpace.init(name: CGColorSpace.genericRGBLinear)!)!
    //    filteredImage = filteredImage.premultiplyingAlpha()
    //    filteredImage = filteredImage.settingAlphaOne(in: filteredImage.extent)
//        path = "/Users/ipdesign/Downloads/maxmin.png"
//        filteredImage.ToPNG(url: URL.init(fileURLWithPath: path))
        if filteredImage.IsValid() == true{
            
            var bitmap = [UInt8](repeating: 0, count: 8)
            
    //        let context1 = CIContext(options: [CIContextOption.workingColorSpace: kCFNull])
            context.render(filteredImage, toBitmap: &bitmap, rowBytes: 8, bounds: CGRect(x: 0, y: 0, width: 2, height: 1), format: .RGBA8, colorSpace: nil)
            
            min = [CGFloat(bitmap[0])/255, CGFloat(bitmap[1])/255, CGFloat(bitmap[2])/255]
            max = [CGFloat(bitmap[4])/255, CGFloat(bitmap[5])/255, CGFloat(bitmap[6])/255]
    //        min = PixelProcess.shared.colorAt(x: 0, y: 0, img: filteredImage)
    //        max = PixelProcess.shared.colorAt(x: 1, y: 0, img: filteredImage)
            print("bigmap: \(bitmap)")
    //        print("total: \(bitmap)")
            return (min, max)
        }

        return (min, max)
    }

    func areaHistogram(img: CIImage) {

        var filteredImage: CIImage = CIImage.init()
        
        guard let filter = CIFilter(name: "CIAreaHistogram") else {
            return
        }

        filter.setValue(img, forKey: "inputImage")
        filter.setValue(img.extent.ToCIVector(), forKey: "inputExtent")
        filter.setValue(12, forKey: "inputCount")
        filter.setValue(1, forKey: "inputScale")
        
        filteredImage = filter.outputImage ?? DataStore.zeroCIImage //Result Correct
    //    filteredImage = filteredImage.unpremultiplyingAlpha()
        filteredImage = filteredImage.settingAlphaOne(in: filteredImage.extent)
    //    filteredImage.matchedFromWorkingSpace(to: CGColorSpace.init(name: CGColorSpace.extendedLinearDisplayP3)!)!

//        let path = "/Users/ipdesign/Downloads/hist.png"
//        filteredImage.ToPNG(url: URL.init(fileURLWithPath: path))
    }

    //func Minimun(_ image: CIImage) -> ([CGFloat]){
    //    var colorValueList: [CGFloat] = [0,0,0]
    //
    //    if image.extent.width > 0 {
    //        guard let filter = CIFilter(name: "CIAreaMinimum") else {
    //            return colorValueList
    //        }
    //        filter.setValue(image, forKey: kCIInputImageKey)
    //        filter.setValue(image.extent.ToCIVector(), forKey: kCIInputExtentKey)
    //        let filteredImage = filter.outputImage ?? DataStore.zeroCIImage //Result Correct
    //        if filteredImage.IsValid() == true{
    //            colorValueList = PixelProcess.shared.colorAt(x: 0, y: 0, img: filteredImage)
    //            return colorValueList
    //        }
    //    }
    //    return colorValueList
    //}

    func NoiseReduction(_ image: CIImage) -> CIImage?{
        
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


}
