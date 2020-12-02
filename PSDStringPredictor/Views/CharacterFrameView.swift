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
    
    let imgUtil = ImageUtil()
    @ObservedObject var imgProcess = imageProcessViewModel
    @State var overText: Bool = false

    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.pink).opacity(0.3)
                .overlay(
                    Rectangle().stroke(Color.pink, lineWidth: 1)
                )
                .frame(width: charFrame.rect.width, height: charFrame.rect.height)
//            Text(charFrame.char)
//                .font(.custom("SF Pro Text", size: 18))
//                .foregroundColor(Color.pink.opacity(0.5))
            //Hover Window
            if(overText == true){
                HoverOnCharView(width: charFrame.rect.width, height: charFrame.rect.height, predictSize: String(charFrame.predictedSize), isVisible: true, positionX: charFrame.rect.midX, positionY: imgProcess.GetTargetImageSize()[1] - (self.charFrame.rect.minY ))
                    .offset(x: 0, y: -60)
            }

        }
        .onTapGesture {
            self.imgProcess.FetchImage()
            var tmpImg: CIImage = CIImage.init()
            if DataStore.colorMode == 1{
                tmpImg = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageProcessed), PositionX: self.charFrame.rect.minX, PositionY: self.charFrame.rect.minY, Width: self.charFrame.rect.width, Height: self.charFrame.rect.height, MaskColor: CIColor.white)
            }else if DataStore.colorMode == 2 {
                tmpImg = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageProcessed), PositionX: self.charFrame.rect.minX, PositionY: self.charFrame.rect.minY, Width: self.charFrame.rect.width, Height: self.charFrame.rect.height, MaskColor: CIColor.gray)
            }
            
            self.imgProcess.SetTargetProcessedImage(tmpImg)
        }
//        .onHover{over in
//            self.overText = over
//        }
        
    }
}

//struct CharacterFrameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterFrameView(id: 1, rect: CGRect(x: 0,y: 0,width: 20,height: 20), char: "A")
//    }
//}
