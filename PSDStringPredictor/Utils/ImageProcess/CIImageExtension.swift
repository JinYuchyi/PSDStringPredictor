
import Foundation
import CoreImage
import AppKit

extension CIImage{

    func ToNSImage()->NSImage{
        //ciImage to NSImage
        let rep = NSCIImageRep(ciImage: self)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
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
        nsimg.pngWrite(to: URL(fileURLWithPath:path+fileName))
    
    }
    
    func ToPNG(url: URL){
        //let newimg = self.cropped(to: rect)
        let nsimg = self.ToNSImage()
        //Save text images to file
        //let path = "/Users/user2/Public/Projects/MacAppTest/MacTest/TestOutput/a\(i).png"
        //nsimg.pngWrite(to: URL(fileURLWithPath: path))
        nsimg.pngWrite(to: url)
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
    


}