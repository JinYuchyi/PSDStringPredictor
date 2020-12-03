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

        }
        .onTapGesture {
            Tapped(rect: charFrame)
        }
        
    }
    
    func Tapped(rect: CGRect){
        let index = imgProcess.maskList.firstIndex(of: rect)
        if index == nil {
            imgProcess.maskList.append(rect)
            print("Add: \(rect), \(imgProcess.maskList.count) in list")

        }else{
            //Delete rect in list
            imgProcess.maskList.remove(at: index!)
            print("Remove: \(rect), \(imgProcess.maskList.count) in list")

        }
        
        if imgProcess.maskList.count == 0 {
            AddCharRectMask()
        }
        
        if DataStore.colorMode == 1{
            for rect in imgProcess.maskList{
                AddCharRectMask()
                
            }
        }else if DataStore.colorMode == 2 {
            for rect in imgProcess.maskList{
                AddCharRectMask()
                
            }
        }
        
    }
    
    func AddCharRectMask(){
        //self.imgProcess.FetchImage()
        self.imgProcess.targetImageMasked = self.imgProcess.targetNSImage.ToCIImage()!
        if DataStore.colorMode == 1{
            for rect in imgProcess.maskList{
                imgProcess.targetImageMasked = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageMasked), PositionX: rect.minX, PositionY: rect.minY, Width: rect.width, Height: rect.height, MaskColor: CIColor.white)
            }
        }else if DataStore.colorMode == 2 {
            for rect in imgProcess.maskList{
                imgProcess.targetImageMasked = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageMasked), PositionX: rect.minX, PositionY: rect.minY, Width: rect.width, Height: rect.height, MaskColor: CIColor.gray)
//                self.imgProcess.SetTargetMaskedImage(tmpImg)
            }
        }
        
    }
    
}

//struct CharacterFrameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterFrameView(id: 1, rect: CGRect(x: 0,y: 0,width: 20,height: 20), char: "A")
//    }
//}
