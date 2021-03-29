
import Foundation
import CoreImage
import Cocoa
import AppKit



extension CIImage{
    
    func ToNSImage()->NSImage{
        //ciImage to NSImage
        let rep = NSCIImageRep(ciImage: self)
        rep.hasAlpha = false
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
    
    func ToCGImage() -> CGImage! {
        let context = CIContext()

        
//        var colorSpace = CGColorSpaceCreateDeviceRGB()
//        context.createCGImage(self, from: self.extent, format: CIFormat.RGBA8, colorSpace: .none)
        
        return context.createCGImage(self, from: self.extent)
    }
    
    func ToPNG(_ rect: CGRect, ToPath path: String, FileName fileName: String, CreatePath createPath: Bool){
        let newimg = self.cropped(to: rect)
        //print("RectW:\(rect.width), RectH:\(rect.height). Mid Image Size: \(newimg.extent), row size: \(self.extent)")
        let nsimg = newimg.ToNSImage()
        //Save text images to file
        //let path = "/Users/user2/Public/Projects/MacAppTest/MacTest/TestOutput/a\(i).png"
        //nsimg.pngWrite(to: URL(fileURLWithPath: path))
        if createPath == true{
            try! FileManager.default.createDirectory(atPath: path,
                                                     withIntermediateDirectories: true, attributes: nil)
        }
        nsimg.pngWrite(atUrl: URL(fileURLWithPath:path+fileName))
        
    }
    
    func GetCroppedImages(rects: [CGRect]) -> [CIImage]{
        self.unpremultiplyingAlpha()
        self.settingAlphaOne(in: self.extent)
        var imgs :[CIImage] = []
        for rect in rects {
            let tmpImg = self.cropped(to: rect).settingAlphaOne(in: self.extent)
            imgs.append(tmpImg)
        }
        return imgs
    }
    
    func ToPNG(url: URL){
//        self.settingAlphaOne(in: self.extent)
//        self.unpremultiplyingAlpha()
        //let newimg = self.cropped(to: rect)
        let nsimg = self.ToNSImage()
        
        //Save text images to file
        //let path = "/Users/user2/Public/Projects/MacAppTest/MacTest/TestOutput/a\(i).png"
        //nsimg.pngWrite(to: URL(fileURLWithPath: path))
        nsimg.pngWrite(atUrl: url)
    }
    
    func ToCGImage(context: CIContext? = nil) -> CGImage? {
        let ctx = context ?? CIContext(options: nil)
        return ctx.createCGImage(self, from: self.extent)
    }
    
    //    /// Create an NSImage version of this image
    //    ///
    //    /// - Returns: Converted image, or nil
    //    func asNSImage() -> NSImage? {
    //       let rep = NSCIImageRep(ciImage: self)
    //       let updateImage = NSImage(size: rep.size)
    //       updateImage.addRepresentation(rep)
    //       return updateImage
    //    }
    
    func IsValid() -> Bool {
        if self.extent.width > 0{
            return true
        }
        else {
            return false
        }
    }
    
    //This function will freeze the app when processing a lot of images
    func toData()-> Data{
        return self.ToNSImage().pngData ?? Data.init()
    }
    
    func scale(size: CGFloat) -> CIImage  {
        var newImg: CIImage = DataStore.zeroCIImage
        func iterScale(_ img: CIImage) {
            let transform = CGAffineTransform.init(scaleX: 1.01, y: 1.01)
            newImg = newImg.transformed(by: transform)
            if newImg.extent.width < size || newImg.extent.height < size {
                iterScale(newImg)
            }
        }
        let scaleX = size / self.extent.width
        let scaleY = size / self.extent.height
        let transform = CGAffineTransform.init(scaleX: scaleX, y: scaleY)
        newImg = self.transformed(by: transform)
        if newImg.extent.width < size || newImg.extent.height < size {
            iterScale(newImg)
        }
        
        if newImg.extent.width > size && newImg.extent.height > size {
            newImg.cropped(to: CGRect.init(x: 0, y: 0, width: size, height: size))
            
        }
        
        return newImg
    }
    
    func getForegroundBackgroundColor(colorMode: MacColorMode)->(foregroundColor: CGColor, backgroundColor: CGColor){
//        if charImageList.count > 0{
        self.settingAlphaOne(in: self.extent)
        self.unpremultiplyingAlpha()
//        print("max: \(Maximum(self))")
//        print("min: \(Minimun(self))")
        let maxmin = MaxMin(img: self)
         var foregroundColor: CGColor = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
        var backgroundColor: CGColor = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
            if colorMode == .light{
//                var minc = NSColor.init(red: 1, green: 1, blue: 1, alpha: 1)
//                var maxc = NSColor.init(red: 0, green: 0, blue: 0, alpha: 1)
//                var i: Int = 0

//                for img in charImageList.filter({$0.extent.width > 0}){
//                    i += 1

//                    if Minimun(img).ToGrayScale() <  minc.ToGrayScale()  {
//                        minc = Minimun(img)
//
//                    }
//                    if Maximum(img).ToGrayScale() >  maxc.ToGrayScale()  {
//                        maxc = Maximum(img)
//                    }
//                }
//                let tmpBGValueList = Maximum(self)
//                let tmpFGValueList = Minimun(self)
                backgroundColor = CGColor.init(red: maxmin.max[0], green: maxmin.max[1], blue: maxmin.max[2], alpha: 1)
                foregroundColor = CGColor.init(red: maxmin.min[0], green: maxmin.min[1], blue: maxmin.min[2], alpha: 1)
                
            }
            
            else if colorMode == .dark{
//                var minc = NSColor.init(red: 1, green: 1, blue: 1, alpha: 1)
//                var maxc = NSColor.init(red: 0, green: 0, blue: 0, alpha: 1)
//                var i: Int = 0
//                for img in charImageList.filter({$0.extent.width > 0}){
//                    i += 1
//                    //Calculate the brightest color as the font color
//                    if Maximum(img).ToGrayScale() >  maxc.ToGrayScale()  {
//                        maxc = Maximum(img)
//
//                    }
//                    //Calculate the darkest color as the background color
//                    if Minimun(img).ToGrayScale() <  minc.ToGrayScale()  {
//                        minc = Minimun(img)
//                    }
//                }
//                bgColor = CGColor.init(red: minc.redComponent, green: minc.greenComponent, blue: minc.blueComponent, alpha: 1)
//                result = CGColor.init(red: maxc.redComponent, green: maxc.greenComponent, blue: maxc.blueComponent, alpha: 1)
//                let tmpBGValueList = Minimun(self)
//                let tmpFGValueList = Maximum(self)
                backgroundColor = CGColor.init(red: maxmin.min[0], green: maxmin.min[1], blue: maxmin.min[2], alpha: 1)
                foregroundColor = CGColor.init(red: maxmin.max[0], green: maxmin.max[1], blue: maxmin.max[2], alpha: 1)
            }
//        }
 
        return (foregroundColor, backgroundColor)
    }
    
    
    
}
