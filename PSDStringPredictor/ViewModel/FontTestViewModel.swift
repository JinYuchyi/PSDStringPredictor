//
//  fontTestViewModel.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 23/2/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import Cocoa

struct FontProperty {
    var ascent: CGFloat = 0
    var descent: CGFloat = 0
    var leading: CGFloat = 0
    var lineHeight: CGFloat = 0
    var capHeight: CGFloat = 0
    var size: CGRect = CGRect.init()
    var xHeight: CGFloat = 0
}

class FontTestViewModel: ObservableObject {
    @Published var fontProperty: FontProperty = FontProperty.init()
    
    init() {
        fontProperty = self.GetFontInfo(Font: "SFProText-Regular", Content: "Ejae.", Size: 25)
    }
    
    func GetFontInfo(Font: String, Content: String, Size: CGFloat) -> FontProperty {
         let tmp = FontUtils.GetFontInfo(Font: Font, Content: Content, Size: Size)
        let prop = FontProperty(ascent: tmp.ascent, descent: tmp.descent, leading: tmp.leading, lineHeight: tmp.lineHeight, capHeight: tmp.capHeight, size: tmp.size, xHeight: tmp.xHeight)
        return prop
        
    }
    

    
    
}
