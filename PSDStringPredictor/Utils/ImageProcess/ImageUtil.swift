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
    
    
}


