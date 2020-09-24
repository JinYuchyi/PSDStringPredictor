import SwiftUI
//
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
        
//        let attributedStringShadow = NSShadow()
//        attributedStringShadow.shadowOffset = NSMakeSize(0.0,0.0)
//        attributedStringShadow.shadowBlurRadius = 5.0
//        attributedStringShadow.shadowColor = NSColor(red:0.0, green:0.0, blue:0.0, alpha:0.333)
        
        var attrString = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: myfont, NSAttributedString.Key.expansion: 0 ])

        let filter = attributedTextImageGenerator(inputText: attrString, inputScaleFactor: NSNumber.init(value: 1))
        let newimg = filter!.outputImage!
        
        let url = URL(fileURLWithPath: "/Users/ipdesign/Downloads/testtext.png")
        newimg.ToPNG(url: url)

        let stringsObjectPredicted = ocr.CreateAllStringObjects(FromCIImage: newimg)
        //print(stringsObjectPredicted[0].stringRect)

        let clampedImg = newimg.cropped(to: stringsObjectPredicted[0].stringRect)
        print(clampedImg.extent.size)
        let url1 = URL(fileURLWithPath: "/Users/ipdesign/Downloads/testtext_clamped.png")
        clampedImg.ToPNG(url: url1)
        
        return newimg
    }
    
//    func CompareImage(_ img1: CIImage, img2: CIImage) -> CGFloat{
//
//    }
    
    func Debug(){
        
    }
    
    func createBitmapContext(img: CGImage) -> CGContext {

        // Get image width, height
        let pixelsWide = img.width
        let pixelsHigh = img.height

        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)

        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let size = CGSize(width: CGFloat(pixelsWide), height: CGFloat(pixelsHigh))
        //CGBitmapContextCreate
        //UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // create bitmap
        let context = CGContext(data: bitmapData,
                                width: pixelsWide,
                                height: pixelsHigh,
                                bitsPerComponent: 8,
                                bytesPerRow: bitmapBytesPerRow,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)

        // draw the image onto the context
        let rect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)

        context?.draw(img, in: rect)
        
        return context!
    }
    
    func colorAt(x: Int, y: Int, img: CGImage)->NSColor {
        
        let context = self.createBitmapContext(img: img)

        assert(0<=x && x < context.width)
        assert(0<=y && y < context.height)
        

        guard let pixelBuffer = context.data else { return .white }
        let data = pixelBuffer.bindMemory(to: UInt8.self, capacity: context.width * context.height)

        let offset = 4 * (y * context.width + x)

        let alpha: UInt8 = data[offset]
        let red: UInt8 = data[offset+1]
        let green: UInt8 = data[offset+2]
        let blue: UInt8 = data[offset+3]

        let color = NSColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)

        return color
    }
    
    func ImageOntop(OverlayImage img1: CIImage, BGImage img2: inout CIImage, OffsetX x: CGFloat = 0, OffsetY y: CGFloat = 0) ->CIImage {
        //Filter Creation
        let filter = CIFilter(name: "CISourceOverCompositing")
        let movedImage = img1.transformed(by: CGAffineTransform(translationX: x, y: y))
        filter!.setDefaults()
        filter!.setValue(movedImage, forKey: "inputImage")
        filter!.setValue(img2, forKey: "inputBackgroundImage")
        
        return  filter!.outputImage!
    }
    
    func AddRectangleMask(BGImage img: inout CIImage, PositionX x: CGFloat, PositionY y: CGFloat, Width w: CGFloat, Height h: CGFloat, MaskColor color: CIColor) -> CIImage{
        //Create mask
        var mask = CIImage.init(color: color)
        let rect = CGRect(x: 0, y: 0, width: w, height: h)
        mask = mask.cropped(to: rect)

        let img = ImageOntop(OverlayImage: mask, BGImage: &img, OffsetX: x, OffsetY: y)
        
        return img
        //Save Image
//        let url = URL(fileURLWithPath: "/Users/ipdesign/Downloads/testtextmask.png")
//        img.ToPNG(url: url)
        
    }
    
    func AddRectangleMask(BGImage img: inout CIImage, Rects rects: [CGRect], MaskColor color: CIColor){
        for i in 0..<rects.count{
            //Create mask
            var mask = CIImage.init(color: color)
            //let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
            mask = mask.cropped(to: rects[i])
            ImageOntop(OverlayImage: mask, BGImage: &img )
        }
        //return img
        //Save Image
//        let url = URL(fileURLWithPath: "/Users/ipdesign/Downloads/testtextmask.png")
//        img.ToPNG(url: url)
        
    }
    
    func OutputAllStringPng(FromImage img: CIImage, ToFolder path: String){
        
        for e in DataStore.stringObjectList {
            let filePath = path + String(e.id.hashValue) + ".png"
            let url = URL(fileURLWithPath: filePath)

            let tmp = img.cropped(to: e.stringRect)
            tmp.ToPNG(url: url)
        }
    }
    
    
    
    
    
    
    
}


