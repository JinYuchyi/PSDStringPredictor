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

func ViewSnapshot(view: View){
    UIGraphicsBeginImageContextWithOptions(view.layer.frame.size, false, scale)
    myView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let viewImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    let data = UIImagePNGRepresentation(viewImage)
    let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    let writePath = documentsDir.stringByAppendingPathComponent("myimage.png")
    data.writeToFile(writePath, atomically:true)
}
