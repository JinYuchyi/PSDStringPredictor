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
    var stringRect: CGRect
    var alignment: StringAlignment
    var content: String
    var isHighLight: Bool
    var pageHeight: CGFloat
    
    var body: some View {
        if alignment == StringAlignment.left {
            ZStack{
                ZStack(alignment: .leading){
                    Rectangle().frame(width: stringRect.width, height: 20).hidden()

                    Text( content)
                        .foregroundColor( isHighLight == true ? Color.red: color.ToColor() )
                        .font(.custom(fontName, size: fontSize))
                        
                }
                .border(Color.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .position(x: stringRect.origin.x + stringRect.width / 2  , y: pageHeight - stringRect.midY)
                

            }

        }else if  alignment == StringAlignment.right  {
            ZStack{

                ZStack(alignment: .trailing){
                    Rectangle().frame(width: stringRect.width, height: 20).hidden()

                    Text( content)
                        .foregroundColor( color.ToColor())
                  
                        .font(.custom( fontName, size: fontSize))

                    

                        
                }
                .border(Color.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .position(x: stringRect.origin.x - stringRect.width / 2  , y: pageHeight - stringRect.midY)


            }
        }else {
            ZStack{

                ZStack(alignment: .center){
                    Rectangle().frame(width: stringRect.width, height: 20).hidden()

                    Text( content)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                  
                        .font(.custom(fontName, size: fontSize))
                    

                        
                }
                .border(Color.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .position(x: stringRect.origin.x   , y: pageHeight - stringRect.midY)
                

            }
        }
    }
}

//struct AlignedText_Previews: PreviewProvider {
//    static var previews: some View {
//        AlignedText()
//    }
//}
