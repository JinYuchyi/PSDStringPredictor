import SwiftUI
import Vision

//extension View {
//    func takeScreenshot(origin: CGPoint, size: CGSize) -> NSImage {
//        let window = NSWindow(frame: CGRect(origin: origin, size: size))
//        let hosting = NSHostingController(rootView: self)
//        hosting.view.frame = window.frame
//        window.addSubview(hosting.view)
//        window.makeKeyAndVisible()
//        return hosting.view.renderedImage
//    }
//}

class ImageUtil{
    let ocr = OCR()
    let pixelProcess = PixelProcess()
    
    private func attributedTextImageGenerator(inputText: NSAttributedString, inputScaleFactor: NSNumber = 1) -> CIFilter? {
        guard let filter = CIFilter(name: "CIAttributedTextImageGenerator") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputText, forKey: "inputText")
        filter.setValue(inputScaleFactor, forKey: "inputScaleFactor")
        //print("filter.inputKeys: \(filter.inputKeys)")
        return filter
    }

    func RenderTextToImage(Content str: String, Color color: NSColor, Size size: CGFloat ) -> CIImage{
        //var mystr = str
        let myfont = CTFontCreateWithName("SFPro-Medium" as CFString, size, nil)

        let attrString = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: myfont, NSAttributedString.Key.expansion: 0 ])

        let filter = attributedTextImageGenerator(inputText: attrString, inputScaleFactor: NSNumber.init(value: 1))
        let newimg = filter!.outputImage!
        
        return newimg
    }

    func ImageOntop(OverlayImage img1: CIImage, BGImage img2: CIImage, OffsetX x: CGFloat = 0, OffsetY y: CGFloat = 0) ->CIImage {
        //Filter Creation
        let filter = CIFilter(name: "CISourceOverCompositing")
        let movedImage = img1.transformed(by: CGAffineTransform(translationX: x, y: y))
        filter!.setDefaults()
        filter!.setValue(movedImage, forKey: "inputImage")
        filter!.setValue(img2, forKey: "inputBackgroundImage")
        
        return  filter!.outputImage!
    }
    
    func AddRectangleMask(BGImage img:  CIImage, PositionX x: CGFloat, PositionY y: CGFloat, Width w: CGFloat, Height h: CGFloat, MaskColor color: CIColor) -> CIImage{
        //Create mask
        let pixelProcess = PixelProcess()
        let nsC = pixelProcess.colorAt(x: Int(x), y: Int(y), img: DataRepository.shared.GetSelectedNSImage().ToCGImage()!)
        let c: CIColor = CIColor.init(red: nsC.redComponent, green: nsC.greenComponent, blue: nsC.blueComponent)
        
        var mask = CIImage.init(color: c)
        let rect = CGRect(x: 0, y: 0, width: w, height: h)
        mask = mask.cropped(to: rect)

        let res = ImageOntop(OverlayImage: mask, BGImage: img, OffsetX: x, OffsetY: y)
        
        return res
    }
    
//    func AddRectangleMask(BGImage img: inout CIImage, Rects rects: [CGRect], MaskColor color: CIColor) -> CIImage{
//        for i in 0..<rects.count{
//            //Create mask
//            var mask = CIImage.init(color: color)
//            //let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//            mask = mask.cropped(to: rects[i])
//            return  ImageOntop(OverlayImage: mask, BGImage: img )
//        }
//
//    }
    
    func imageDataProperties(_ imageData: Data) -> NSDictionary? {
        if let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil)
        {
          if let dictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) {
            return dictionary
          }
        }
        return nil
      }
    
    static func GetImageProperty(keyName: String, path: String) -> String{

        let url = URL.init(fileURLWithPath: path)

        var imageData: NSData =  NSData.init()
            do{
                try imageData = NSData.init(contentsOf: url)
            }catch{
                print("Image data generate error in getting DPI function.")
            }
            

        let imageSource = CGImageSourceCreateWithData(imageData, nil)
        let metaData = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil) as? [String: Any]
        let dpi = metaData![keyName] as! String
        print(dpi)
            return dpi

    }
    
    func ApplyFilters(target: CIImage, gamma: CGFloat, exp: CGFloat)->CIImage{
        if (target.IsValid()){
            var tmp = ChangeGamma(target, gamma)!
            tmp = ChangeExposure(tmp, exp)!
//            if isConvolution == true{
//                tmp = SetConv(tmp)!
//            }
            return tmp
        }
        return target
    }

    func ApplyBlockMasks(target: CIImage, psdId: Int ) -> CIImage{
        var result: CIImage = CIImage.init()
        //self.imgProcess.FetchImage()
        //self.imgProcess.targetImageMasked = self.imgProcess.targetNSImage.ToCIImage()!
        if DataRepository.shared.GetBlockMaskListDict()[psdId] == nil || DataRepository.shared.GetBlockMaskListDict()[psdId]!.count == 0{
            return target
        }
        if DataRepository.shared.GetColorMode(psdId: psdId) == 1{
            for rect in DataRepository.shared.GetBlockMaskListDict()[psdId]!{
                result = AddRectangleMask(BGImage: (target), PositionX: rect.minX, PositionY: rect.minY, Width: rect.width, Height: rect.height, MaskColor: CIColor.white)
            }
        }else if psdViewModel.psdColorMode[psdId]  == 2 {
            for rect in DataRepository.shared.GetBlockMaskListDict()[psdId]!{
                result = AddRectangleMask(BGImage: (target), PositionX: rect.minX, PositionY: rect.minY, Width: rect.width, Height: rect.height, MaskColor: CIColor.gray)
//                self.imgProcess.SetTargetMaskedImage(tmpImg)
            }
        }
        return result
        
    }

    
    
    
    
}


