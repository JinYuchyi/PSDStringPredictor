//
//  CharacterFrameView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 17/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct CharacterFrameView: View {
    var charFrame: CharFrame
    var body: some View {
        ZStack{
            Rectangle()
                .stroke(Color.red, lineWidth: 1)
                .frame(width: charFrame.rect.width, height: charFrame.rect.height)
                //.position(x: charFrame.rect.midX, y: charFrame.rect.midY)
            Text(charFrame.char)
                .font(.custom("SF Pro Text", size: 12))
                .foregroundColor(Color.red.opacity(0.5))
                //.position(x: charFrame.rect.midX, y: charFrame.rect.midY)
        }
    }
}

//struct CharacterFrameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterFrameView(id: 1, rect: CGRect(x: 0,y: 0,width: 20,height: 20), char: "A")
//    }
//}
