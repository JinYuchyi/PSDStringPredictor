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
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
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
      return self.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)
    }
}
