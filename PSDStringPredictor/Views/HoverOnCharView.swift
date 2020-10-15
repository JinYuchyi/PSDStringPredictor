//
//  HoverOnCharView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct HoverOnCharView: View {
    var width: CGFloat
    var height: CGFloat
    var predictSize: String
    let frameWidth: CGFloat = 130.0
    let frameHeight: CGFloat = 80.0
    
    @State var isVisible:Bool
    var positionX: CGFloat
    var positionY: CGFloat
    
    var body: some View {
        ZStack{
            //if (isVisible){
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: frameWidth, height: frameHeight)
                    //.position(x: positionX, y: positionY)

                VStack{
                    Text("Width: \(width)\nHeight: \(height)\nSize: \(predictSize)")
                        .padding(.all, 10.0)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: frameWidth, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: frameHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                        .font(.custom("SF Pro text", size: 12))
                        .lineSpacing(5)
                        //.position(x: positionX, y: positionY)

                }
            //}
        }
        
    }
}

struct HoverOnCharView_Previews: PreviewProvider {
    static var previews: some View {
        HoverOnCharView(width: 10, height: 20, predictSize: "50", isVisible: true, positionX: 200, positionY: 200)
        //.offset(x: 100, y: 100)
    }
}
