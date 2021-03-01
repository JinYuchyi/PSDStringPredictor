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
//            return  (descent + (ascent - xheight)) * fontDecentOffsetScale
            return descent * fontDecentOffsetScale
        }else if hasLongTail == true && hasHat == false {
            let descent = FontUtils.GetFontInfo(Font: fontName, Content: content, Size: fontSize).descent
            return descent * fontDecentOffsetScale
        }
        
        return descent
    }
    
    static func GetStringBound(str: String, fontName: String, fontSize: CGFloat, tracking: CGFloat) -> CGRect{
        //So far the size is correct, but the Y position is not
        //TODO: Calc tracking related bound
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
                    c == "("
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
//        let framesetter = CTFramesetterCreateWithAttributedString(text as CFAttributedString)
//        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, text.length), path, nil)

        let line = CTLineCreateWithAttributedString(text)
        let runs = CTLineGetGlyphRuns(line) as! [CTRun]
        let runPositionsPointer = CTRunGetPositionsPtr(runs[0])
        let runPosition = runPositionsPointer?.pointee
        let b = (CTRunGetImageBounds(runs[0], nil, CFRange(location: 0,length: 0)))
        
        var fixb = CGRect.init(x: runPosition!.x, y: b.origin.y, width: b.width, height: b.height)
        if hasHat == true && hasLongTail == true {
            let totalHeight = CTFontGetBoundingBox(font)
//            let vWhiteH = totalHeight.height - CTFontGetAscent(font) - CTFontGetDescent(font)
            let offset = CTFontGetAscent(font) - CTFontGetXHeight(font) - CTFontGetDescent(font) - fontSize / 15
//            print(vWhiteH)
            fixb = CGRect.init(x: runPosition!.x, y: b.origin.y + offset/2 , width: b.width, height: b.height )
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
