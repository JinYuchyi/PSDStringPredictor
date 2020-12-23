//
//  CharacterFrameView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 17/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct CharacterFrameView: View {
    //Constant
    let cornerRadious: CGFloat = 5
    let fillColor: Color = Color.purple.opacity(0.3)
    
    //var charFrame: CGRect
    //var IDList: [UUID]
    let imgUtil = ImageUtil()
    @ObservedObject var imgProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM = stringObjectViewModel
    @State var overText: Bool = false
    //@State var isMasked: Bool = false

    var body: some View {
        ZStack{
            ForEach(stringObjectVM.charFrameListData, id:\.id){item in
                RoundedRectangle(cornerRadius: 5)
                    .fill(fillColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 1)
                            .shadow(radius: 0.5)
                    )
                    //.shadow(radius: 1)
                    .frame(width: item.rect.width, height: item.rect.height)
                    .position(x: item.rect.minX + item.rect.width/2, y: imgProcess.targetNSImage.size.height - item.rect.minY - item.rect.height/2)
                    .onTapGesture {
                        Tapped(rect: item.rect)
                    }
            }
            

        }
        
        
    }
    
    func Tapped(rect: CGRect){
        let index = imgProcess.maskList.firstIndex(of: rect)
        if index == nil {
            imgProcess.maskList.append(rect)
            //isMasked = true
            //print("add")

        }else{
            //Delete rect in list
            imgProcess.maskList.remove(at: index!)
            //isMasked = false
            //print("remove")

        }
        
        if imgProcess.maskList.count == 0 {
            AddCharRectMask()
        }
        
        if DataStore.colorMode == 1{
            for _ in imgProcess.maskList{
                AddCharRectMask()
            }
        }else if DataStore.colorMode == 2 {
            for _ in imgProcess.maskList{
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
                imgProcess.targetImageMasked = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageMasked), PositionX: rect.minX, PositionY: rect.minY, Width: rect.width, Height: rect.height, MaskColor: CIColor.black)
//                self.imgProcess.SetTargetMaskedImage(tmpImg)
            }
        }
        
        self.imgProcess.SetFilter()
        
    }
    
}

//struct CharacterFrameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterFrameView(id: 1, rect: CGRect(x: 0,y: 0,width: 20,height: 20), char: "A")
//    }
//}
