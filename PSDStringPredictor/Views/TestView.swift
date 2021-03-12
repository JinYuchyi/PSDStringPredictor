//
//  testView.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 11/3/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct testView: View {
    let fontSize: CGFloat = 200
    let tracking: CGFloat = 0
    let fontName: String = "SF Pro Text Regular"
    @State var content: String = "MtAsh"
    @State var x: CGFloat = 0
    
    let posX: CGFloat = 150
    let posY: CGFloat = 150
    
    var body: some View {
        ZStack(alignment: .center){

            Rectangle()
                .frame(width: getBound().width, height: getBound().height)
                .position(x: posX + getBound().width / 2 , y: posY)
            
            Text(content)
                .tracking(tracking)
                .foregroundColor(Color.red)
                .font(.custom(fontName, size: fontSize))
                .position(x: posX  + getBound().width / 2   , y: posY)
                .ignoresSafeArea()
                .onTapGesture {
                    x = FontUtils.getFrontSpace(content: content, fontSize: fontSize)
                    print(x)
                }

            Rectangle()
                .foregroundColor(.red)
                .frame(width:1, height: 1)
                .position(x: posX , y: posY)
        }
    }
    
    func  getBound() -> CGRect {
        return FontUtils.GetStringBound(str: content, fontName: fontName, fontSize: fontSize, tracking: tracking)
    }
    
    
//    func getOffset(str: String) -> CGFloat {
//        let firstStr = String(str.first!)
//        let number = DataStore.charOffsetInFront[firstStr]!
//
//        return  (number)
////        return CGFloat(DataStore.charOffsetInFront[firstStr]!)
//     }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
            .previewLayout(.sizeThatFits)
    }
}
