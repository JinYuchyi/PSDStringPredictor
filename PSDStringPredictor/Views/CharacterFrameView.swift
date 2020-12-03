//
//  CharacterFrameView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 17/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct CharacterFrameView: View {
    
    //var charFrame: CharFrame
    var charFrame: CGRect
    let imgUtil = ImageUtil()
    @ObservedObject var imgProcess = imageProcessViewModel
    @State var overText: Bool = false

    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.pink).opacity(0.1)
                .overlay(
                    Rectangle().stroke(Color.pink, lineWidth: 1)
                )
                .frame(width: charFrame.width, height: charFrame.height)

            //Hover Window
//            if(overText == true){
//                HoverOnCharView(width: charFrame.rect.width, height: charFrame.rect.height, predictSize: String(charFrame.predictedSize), isVisible: true, positionX: charFrame.rect.midX, positionY: imgProcess.GetTargetImageSize()[1] - (self.charFrame.rect.minY ))
//                    .offset(x: 0, y: -60)
//            }

        }
        .onTapGesture {
            self.imgProcess.FetchImage()
            var tmpImg: CIImage = CIImage.init()
            if DataStore.colorMode == 1{
                tmpImg = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageProcessed), PositionX: self.charFrame.minX, PositionY: self.charFrame.minY, Width: self.charFrame.width, Height: self.charFrame.height, MaskColor: CIColor.white)
            }else if DataStore.colorMode == 2 {
                tmpImg = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageProcessed), PositionX: self.charFrame.minX, PositionY: self.charFrame.minY, Width: self.charFrame.width, Height: self.charFrame.height, MaskColor: CIColor.gray)
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
