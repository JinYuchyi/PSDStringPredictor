//
//  CharacterFrameView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 17/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct CharacterFrameView: View {
    let imgUtil = ImageUtil()
    @ObservedObject var imgProcess = imageProcessViewModel
    //@ObservedObject var strObjVM = StringObjectViewModel()
    
    var charFrame: CharFrame
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.pink).opacity(0.3)
                .overlay(
                    Rectangle().stroke(Color.pink, lineWidth: 1)
                )
                .frame(width: charFrame.rect.width, height: charFrame.rect.height)
                //.position(x: charFrame.rect.midX, y: charFrame.rect.midY)
            Text(charFrame.char)
                .font(.custom("SF Pro Text", size: 18))
                .foregroundColor(Color.pink.opacity(0.5))
                //.position(x: charFrame.rect.midX, y: charFrame.rect.midY)
        }
        .onTapGesture {
            self.imgProcess.FetchImage()
            let tmpImg = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageProcessed), PositionX: self.charFrame.rect.minX, PositionY: self.charFrame.rect.minY, Width: self.charFrame.rect.width, Height: self.charFrame.rect.height, MaskColor: CIColor.white)
            self.imgProcess.SetTargetProcessedImage(tmpImg)
        }
        
    }
}

//struct CharacterFrameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterFrameView(id: 1, rect: CGRect(x: 0,y: 0,width: 20,height: 20), char: "A")
//    }
//}
