
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
    
    func ToPNG(_ rect: CGRect, ToPath path: String, CreatePath createPath: Bool){
        let newimg = self.cropped(to: rect)
        print("RectW:\(rect.width), RectH:\(rect.height). Mid Image Size: \(newimg.extent), row size: \(self.extent)")
        let nsimg = newimg.ToNSImage()
        //Save text images to file
        //let path = "/Users/user2/Public/Projects/MacAppTest/MacTest/TestOutput/a\(i).png"
        //nsimg.pngWrite(to: URL(fileURLWithPath: path))
        if createPath == true{
            try! FileManager.default.createDirectory(atPath: path,
            withIntermediateDirectories: true, attributes: nil)
        }
        nsimg.pngWrite(to: URL(string:path)!)
    
    }
    
    func ToPNG(url: URL){
        //let newimg = self.cropped(to: rect)
        let nsimg = self.ToNSImage()
        //Save text images to file
        //let path = "/Users/user2/Public/Projects/MacAppTest/MacTest/TestOutput/a\(i).png"
        //nsimg.pngWrite(to: URL(fileURLWithPath: path))
        nsimg.pngWrite(to: url)
    }
    

}
