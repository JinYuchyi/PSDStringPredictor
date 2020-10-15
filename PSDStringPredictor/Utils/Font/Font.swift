//
//  Font.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 29/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class FontUtils {
    func GetFontInfo(Font font: String, Content content: String, Size size: CGFloat) -> (ascent: CGFloat, descent: CGFloat, leading:CGFloat, lineHeight:CGFloat, capHeight: CGFloat, size: CGRect ) {
        var info: (ascent:CGFloat, descent:CGFloat, leading:CGFloat, lineHeight:CGFloat, capHeight: CGFloat, size: CGRect )
        
//        let fontDescriptorAttributes = [
//            kCTFontNameAttribute: font,
//            kCTFontCharacterSetAttribute: 
//            //kCTFontTraitsAttribute: [
//                //kCTFontWeightTrait: NSFont.Weight.black
//                
//            //]
//            
//        ] as [CFString : Any]
        
        var font = CTFontCreateWithName(font as CFString, size, nil)
        font = CTFontCreateForString(font, content as CFString, CFRange(location: 0, length: content.count))
        info.capHeight = CTFontGetCapHeight(font)
        info.ascent = CTFontGetAscent(font)
        info.descent = CTFontGetDescent(font)
        info.leading = CTFontGetLeading(font)
        info.size = CTFontGetBoundingBox(font)
        //CTFrameDraw(<#T##frame: CTFrame##CTFrame#>, <#T##context: CGContext##CGContext#>)
        info.lineHeight = info.ascent + info.descent + info.leading
        
        //print(info)
        
        return info
    }
}
