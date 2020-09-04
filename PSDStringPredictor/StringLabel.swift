//
//  StringLabel.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringLabel: View {
    var position: [CGFloat] = GetPosition()
    var height: CGFloat = GetHeight()
    var width: CGFloat = GetWidth()
    var fontsize: CGFloat = GetFontSize()
    var tracking: CGFloat = GetTracking()
    var stringContent: String = GetStringContent()
    
    var body: some View {
        ZStack{
            Rectangle()
            .fill(Color(red: 1, green: 0, blue: 0, opacity: 0.3))
                .frame(width: self.width, height: self.height)
            
            Text(GetStringContent())
                .font(.system(size: self.fontsize, weight: .light, design: .serif))

        }
        .position(x: GetPosition()[0], y: GetPosition()[1])
    }
}

struct StringLabel_Previews: PreviewProvider {
    static var previews: some View {
        StringLabel(
            position: GetPosition(),
            height: GetHeight(),
            width: GetWidth(),
            fontsize: GetFontSize(),
            tracking: GetTracking(),
            stringContent: GetStringContent()
        )
    }
}

func GetPosition() -> [CGFloat] {
    //let x = Int.random(in: 0..<100)
    //let y = Int.random(in: 0..<100)
    return [200, 200]
}

func GetHeight() -> CGFloat {
    return 20
}

func GetWidth() -> CGFloat {
    return 20
}

func GetFontSize() -> CGFloat {
    return 20
}

func GetTracking() -> CGFloat {
    return 20
}

func GetStringContent() -> String{
    return "Default " +  GetPosition()[0].description  + ", " +  GetPosition()[1].description  
}
