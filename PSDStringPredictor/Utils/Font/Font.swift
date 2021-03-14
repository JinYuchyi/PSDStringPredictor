//
//  Font.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 29/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import Cocoa

class FontUtils {
    
    
    
    static func  calcFontTailLength(content: String, size: CGFloat) -> CGFloat {
        for c in Array(content) {
            if String(c) == "p" || String(c) == "q" || String(c) == "g" || String(c) == "y" || String(c) == "j" || String(c) == "," || String(c) == ";" || String(c) == "/" || String(c) == "(" {
                return size * 18 / 100
            }
        }
        return 0
    }
    
    static func GetCharFrontOffset(content: String, fontSize: CGFloat) -> CGFloat {
        guard let first = content.first else {return 0}
        guard let number = DataStore.charOffsetInFront[String(first)] else {return 0}
            let result = number * fontSize / 100 / 2
            return  result
 
    }
    
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
    
    static func getFrontSpace(content: String, fontSize: CGFloat)-> CGFloat {
//        var frontSpace: CGFloat = 0
        guard let theChar: Character = content.first else {return 0}
        guard var frontSpace = DataStore.frontSpaceDict[String(theChar)] else {return 0}
//        if theChar.isLetter == true || theChar.isNumber == true {
//            frontSpace = DataStore.frontSpaceDict[String(theChar)]!
        frontSpace = frontSpace * fontSize / 100
//        }
        return frontSpace
    }
    
    static func FetchTailOffset(content: String, fontSize: CGFloat) -> CGFloat{
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
                    c == ";" ||
                c == "/"
            ) {
                hasLongTail = true
            }
            if (c.isUppercase || c.isNumber || c == "i" || c == "j" || c == "k" || c == "b" || c == "d" || c == "f" || c == "h" || c == "l" ) {
                hasHat = true
            }
        }
        
        var fontName: String = ""
        if (fontSize / 3 >= 20) {
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
            return descent * fontDecentOffsetScale
        }else if hasLongTail == true && hasHat == false {
            let descent = FontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize).descent
            return descent * fontDecentOffsetScale
        }
        
        return descent
    }
    
    static func GetStringBound(str: String, fontName: String, fontSize: CGFloat, tracking: CGFloat) -> CGRect{
        //So far the size is correct, but the Y position is not
        var hasHat: Bool = false
        var hasLongTail: Bool = false
        for c in str {
            if (
                c == "p" ||
                c == "q" ||
                c == "g" ||
                c == "y" ||
                c == "j" ||
                c == "," ||
                c == ";" ||
                c == ")" ||
                c == "(" ||
                c == "/"
            ) {
                hasLongTail = true
            }
            if (c.isUppercase || c.isNumber || c == "i" || c == "j" || c == "k" || c == "b" || c == "d" || c == "f" || c == "h" || c == "l" || c == ")" ||
                c == "(" ) {
                hasHat = true
            }
        }
        
        var font = CTFontCreateWithName(fontName as CFString, fontSize, nil)
        font = CTFontCreateForString(font, str as CFString, CFRange(location: 0, length: str.count))
        let attrs:[NSAttributedString.Key: Any] = [
            
            kCTForegroundColorAttributeName as NSAttributedString.Key: CGColor.white,
                kCTFontAttributeName as NSAttributedString.Key: font,
            kCTTrackingAttributeName as NSAttributedString.Key: tracking
            ]
        let text = NSAttributedString(string: str, attributes: attrs)

        let line = CTLineCreateWithAttributedString(text)
        let runs = CTLineGetGlyphRuns(line) as! [CTRun]
        let runPositionsPointer = CTRunGetPositionsPtr(runs[0])
        let runPosition = runPositionsPointer?.pointee
        let b = (CTRunGetImageBounds(runs[0], nil, CFRange(location: 0,length: 0)))
//        let b = CTRunGetTypographicBounds(runs[0], CFRange(location: 0,length: 0), nil, nil, nil)
        
        var fixb = CGRect.init(x: b.minX , y: b.minY, width: b.width , height: b.height)
        
        
        // TODO: Check if it can be deleted
        if hasHat == true && hasLongTail == true {
            let offset = CTFontGetAscent(font) - CTFontGetXHeight(font) - CTFontGetDescent(font) - fontSize / 15
            fixb = CGRect.init(x: b.minX, y: b.minY + offset/2 , width: b.width , height: b.height )
        }
        return fixb
    }
    
//    func getGlyphRect() -> [CGRect] {
//        guard let context = NSGraphicsContext.current?.cgContext else { return [] }
//
//        context.textMatrix = .identity
//        context.translateBy(x: 0, y: self.bounds.size.height)
//        context.scaleBy(x: 1.0, y: -1.0)
//
//
// //       let string = "｜優勝《ゆうしょう》の｜懸《か》かった｜試合《しあい》。｜Test《テスト》.\nThe quick brown fox jumps over the lazy dog. 12354567890 @#-+"
//         let string = "ajEc.)"
//
//
//        let attributedString = Utility.sharedInstance.furigana(String: string)
//
//        let range = attributedString.mutableString.range(of: attributedString.string)
//
//        attributedString.addAttribute(.font, value: font, range: range)
//
//
//        let framesetter = attributedString.framesetter()
//
//        let textBounds = self.bounds.insetBy(dx: 20, dy: 20)
//
//        let frame = framesetter.createFrame(textBounds)
//
// //Draw the frame text:
//
//        frame.draw(in: context)
//
//        let origins = frame.lineOrigins()
//
//        let lines = frame.lines()
//
//         context.setStrokeColor(UIColor.red.cgColor)
//         context.setLineWidth(0.7)
//
//         for i in 0 ..< origins.count {
//
//             let line = lines[i]
//
//             for run in line.glyphRuns() {
//
//                 let font = run.font
//                 let glyphPositions = run.glyphPositions()
//                 let glyphs = run.glyphs()
//
//                 let glyphsBoundingRects =  font.boundingRects(of: glyphs)
//
// //DRAW the bounding box for each glyph:
//
//                 for k in 0 ..< glyphPositions.count {
//                     let point = glyphPositions[k]
//                     let gRect = glyphsBoundingRects [k]
//
//                     var box = gRect
//                     box.origin +=  point + origins[i] + textBounds.origin
//                     context.stroke(box)
//
//                 }// for k
//
//             }//for run
//
//        }//for i
//    }

    
    
}
