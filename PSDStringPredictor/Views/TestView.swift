//
//  testView.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 11/3/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct testView: View {
    let fontSize: CGFloat = 100
    let tracking: CGFloat = 0
    let fontName: String = "SF Pro Text Regular"
    @State var content: String = "HeoA"
    @State var x: CGFloat = 0
    
    let posX: CGFloat = 150
    let posY: CGFloat = 150
    
    var body: some View {
        ZStack{
            

            Rectangle()
//                .border(Color.red.opacity(0.2))
                .frame(width: getBound().width, height: getBound().height)
                .position(x: posX, y: posY)
            Text(content)
                .tracking(tracking)

                .foregroundColor(Color.white)
                .font(.custom(fontName, size: fontSize))
                .position(x: posX + getBound().width / 2, y: posY)
                .onTapGesture {
                    x = FontUtils.getFrontSpace(content: content, fontSize: fontSize)
                    print(x)
                }
            
            Rectangle()
//                .border(Color.red.opacity(0.2))
                .foregroundColor(.red)
                .frame(width:1, height: 1)
                .position(x: posX, y: posY)


        }
    }
    
    func  getBound() -> CGRect {
        return FontUtils.GetStringBound(str: content, fontName: fontName, fontSize: fontSize, tracking: tracking)
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
