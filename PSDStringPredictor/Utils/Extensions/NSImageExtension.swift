//
//  NSImageExtension.swift
//  MacTest
//
//  Created by ipdesign on 16/7/2020.
//  Copyright © 2020 yuqi_jin. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
//    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
//        do {
//            try pngData?.write(to: url, options: options)
//            return true
//        } catch {
//            print(error)
//            return false
//        }
//    }
    
    func pngWrite(atUrl url: URL) {
        guard
            let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil)
            else { return } 
        let newRep = NSBitmapImageRep(cgImage: cgImage)
        //newRep.size = self.size // if you want the same size
        guard
            let pngData = newRep.representation(using: .bmp, properties: [:])
            else { return } 
        do {
            try pngData.write(to: url)
        }
        catch {
            print("error saving: \(error)")
        }
    }
    
    func ToCIImage() -> CIImage? {
       if let cgImage = self.ToCGImage() {
          return CIImage(cgImage: cgImage)
       }
       return nil
    }
    
    func ToCGImage() -> CGImage? {
      var rect = NSRect(origin: CGPoint(x: 0, y: 0), size: self.size)
      return cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)
    }
    
    func Trim(rect: CGRect) -> NSImage {
        let result = NSImage(size: rect.size)
        result.lockFocus()

        let destRect = CGRect(origin: .zero, size: result.size)
        self.draw(in: destRect, from: rect, operation: .copy, fraction: 1.0)

        result.unlockFocus()
        return result
    }
    
    func resize(_ to: Int, isPixels: Bool = false) -> NSImage {
        
//        var toSize = to
//        let screenScale: CGFloat = NSScreen.main?.backingScaleFactor ?? 1.0

//        if isPixels {
//
//            toSize.width = to.width / screenScale
//            toSize.height = to.height / screenScale
//        }
//        var nw = size.width
//        var nh = size.height
        var tw: Int = 0
        var th: Int = 0
        if size.width >= size.height {
            tw = to
            let r: CGFloat = CGFloat(to) / size.width
            th = Int((r * size.height).rounded())
        }else {
            th = to
            let r: CGFloat = CGFloat(to) / size.height
            tw = Int((r * size.width).rounded())
        }
        
    
        let toRect = NSRect(x: 0, y: 0, width: tw, height: th)
        let fromRect =  NSRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let newImage = NSImage(size: toRect.size)
        newImage.lockFocus()
        draw(in: toRect, from: fromRect, operation: NSCompositingOperation.copy, fraction: 1.0)
        newImage.unlockFocus()
    
        return newImage
    }
    

 
}
