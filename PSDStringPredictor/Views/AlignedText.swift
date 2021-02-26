//
//  AlignedText.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 24/2/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct AlignedText: View {
//    var align: String
//    var posX: CGFloat
//    var posY: CGFloat
//    var str: String
//    var fontName: String
//    var fontSize: CGFloat
//    var pageWidth: CGFloat
//    var stringWidth: CGFloat
//    @ObservedObject var psdsVM: PsdsVM
//    var stringObject: StringObject
    var fontSize: CGFloat
    var fontName: String
    var color: CGColor
    var posX: CGFloat
    var posY: CGFloat
    var width: CGFloat
    var height: CGFloat
    var alignment: StringAlignment
    var content: String
    var isHighLight: Bool
    var pageWidth: CGFloat
    var pageHeight: CGFloat
    
    
    
    var body: some View {
        if alignment == StringAlignment.left {
                ZStack(alignment: .topLeading){
                    Rectangle().frame(width: width, height: 20)
//                        .padding()

                    Text( content)
                        .foregroundColor( isHighLight == true ? Color.red: color.ToColor() )
                        .font(.custom(fontName, size: fontSize))
                        .fixedSize(horizontal: true, vertical: true)
                    
                }
                .border(Color.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .position(x: width / 2  , y: height / 2)
                .frame(width: width, height: height)

        }else if  alignment == StringAlignment.right  {

                ZStack(alignment: .topTrailing){
                    Rectangle().frame(width: width, height: 20)

                    Text( content)
                        .foregroundColor( color.ToColor())
                        .font(.custom( fontName, size: fontSize))
                }
                .border(Color.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .position(x: width / 2, y: height / 2)
                .frame(width: width, height: height)
//                .frame(width: pageWidth, height: pageHeight)

            
        }else {

                ZStack(alignment: .center){
                    Rectangle().frame(width: width, height: 20).hidden()

                    Text( content)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .font(.custom(fontName, size: fontSize))
                }
                .border(Color.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .position(x: width / 2   , y: height / 2)
                .frame(width: width, height: height)
//                .frame(width: pageWidth, height: pageHeight)

        }
    }
}

struct AlignedText_Previews: PreviewProvider {
    static var previews: some View {
//        AlignedText(fontSize: 100, fontName: "SF Pro Text Regular", color: CGColor.white, stringRect: CGRect.init(x: 100, y: 300, width: 500, height: 150), alignment: .right, content: "aswww", isHighLight: true, pageWidth: 500, pageHeight: 600)
        AlignedText(fontSize: 100, fontName: "SF Pro Text Regular", color: CGColor.white, posX: 100, posY: 300, width: 400, height: 150, alignment: .right, content: "abc", isHighLight: true, pageWidth: 1000, pageHeight: 1000)
    }
}
