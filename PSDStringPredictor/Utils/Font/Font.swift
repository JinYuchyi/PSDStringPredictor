//
//  Font.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 29/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class FontUtils {
    static func GetFontInfo(Font font: String, Content content: String, Size size: CGFloat) -> (ascent: CGFloat, descent: CGFloat, leading:CGFloat, lineHeight:CGFloat, capHeight: CGFloat, size: CGRect, xHeight: CGFloat ) {
        var info: (ascent:CGFloat, descent:CGFloat, leading:CGFloat, lineHeight:CGFloat, capHeight: CGFloat, size: CGRect, xHeight: CGFloat )
        
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
        info.xHeight = CTFontGetXHeight(font)
        //CTFrameDraw(<#T##frame: CTFrame##CTFrame#>, <#T##context: CGContext##CGContext#>)
        info.lineHeight = info.ascent + info.descent + info.leading
        
        return info
    }
    
    static func FetchFontOffset(content: String, fontSize: CGFloat) -> CGFloat{
        var hasLongTail = false
        var hasHat = false
        
        for c in content {
            if (
                c == "p" ||
                    c == "q" ||
                    c == "g" ||
                    c == "y" ||
                    c == "j" ||
                    c == "," ||
                    c == ";"
            ) {
                hasLongTail = true
            }
            if (c.isUppercase || c.isNumber || c == "i" || c == "j" || c == "k" || c == "b" || c == "d" || c == "f" || c == "h" || c == "l" ) {
                hasHat = true
            }
        }
        
        var fontName: String = ""
        if (fontSize >= 20) {
            fontName = "SFProDisplay-Regular"
        }
        else{
            fontName = "SFProText-Regular"
        }
        
        var descent: CGFloat = 0
        if hasLongTail == true && hasHat == true{
            let descent = FontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize).descent
            let ascent = FontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize).ascent
            let xheight = FontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize).xHeight
            return  (descent - (ascent - xheight)) * fontDecentOffsetScale
        }else if hasLongTail == true && hasHat == false {
            let descent = FontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize).descent
            return descent * fontDecentOffsetScale
        }
        
        return descent
    }
}
