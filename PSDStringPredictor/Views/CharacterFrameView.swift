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
    //    @ObservedObject var imgProcess = imageProcessViewModel
    //    @ObservedObject var stringObjectVM = psdViewModel
    @State var overText: Bool = false
    @State var rectList: [CGRect] = []
    @ObservedObject var psdVM: PsdsVM
    
    
    fileprivate func CharFrameView() -> some View{
        
        ZStack{
            ForEach(rectList, id:\.self){item in
                RoundedRectangle(cornerRadius: 3)
                    .fill(fillColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.white, lineWidth: 1)
                            .shadow(radius: 0.5)
                    )
                    .frame(width: item.width, height: item.height)
                    .position(x: item.minX + item.width/2, y: psdVM.selectedNSImage.size.height - item.minY - item.height/2)
                    .onTapGesture {
                        Tapped(rect: item)
                    }
            }
        }
        .onAppear(perform: {rectList = GetRectArray()})

    }
    
    var body: some View {
        CharFrameView()
        
        
    }
    
    //    func ShowDefault() -> Bool{
    //        if stringObjectVM.charFrameListData[stringObjectVM.selectedPSDID]! == nil {
    //            return true
    //        }else {
    //            return false
    //        }
    //    }
    
    func GetRectArray() -> [CGRect] {
        guard let psdObj = psdVM.GetSelectedPsd() else {return []}
        var result = [CGRect]()
        for obj in psdObj.stringObjects {
            result.append(contentsOf: obj.charRects)
        }
        
        return result
    }
    
    func Tapped(rect: CGRect){
        //GetTapArea bg color
        var theColor: CGColor = CGColor.init(srgbRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        for str in psdVM.GetSelectedPsd()!.stringObjects{
            if rect.intersects(str.stringRect) == true {
                theColor = str.bgColor
            }
        }
        
        if psdVM.maskDict[psdVM.selectedPsdId] == nil {
            psdVM.maskDict[psdVM.selectedPsdId] = []
            psdVM.maskColorDict[psdVM.selectedPsdId] = []
        }
        let contain = psdVM.maskDict[psdVM.selectedPsdId]!.contains(rect)
        //print(contain)
        if contain == false {
            psdVM.maskDict[psdVM.selectedPsdId]!.append(rect)
            psdVM.maskColorDict[psdVM.selectedPsdId]!.append(theColor)
            psdVM.UpdateProcessedImage(psdId: psdVM.selectedPsdId)
        }else{
            //Delete rect in list
            let _index = psdVM.maskDict[psdVM.selectedPsdId]!.lastIndex(where: {$0 == rect})
            psdVM.maskDict[psdVM.selectedPsdId]!.remove(at: _index!)
            psdVM.maskColorDict[psdVM.selectedPsdId]!.remove(at: _index!)
            //isMasked = false
            psdVM.UpdateProcessedImage(psdId: psdVM.selectedPsdId)
        }
        
        if psdVM.maskDict.count == 0 {
            //AddCharRectMask()
            psdVM.UpdateProcessedImage(psdId: psdVM.selectedPsdId)
        }

        
    }
    
    func AddCharRectMask(){
        
//        if psdVM.GetSelectedPsd()!.colorMode  == MacColorMode.light{
//            for rect in psdVM.maskDict[psdVM.selectedPsdId]!{
//                psdVM.maskedImage = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageMasked), PositionX: rect.minX, PositionY: rect.minY, Width: rect.width, Height: rect.height, MaskColor: CIColor.white)
//            }
//        }else if psdVM.GetSelectedPsd()!.colorMode  == MacColorMode.dark {
//            for rect in imgProcess.maskList[psdViewModel.selectedPSDID]! {
//                imgProcess.targetImageMasked = self.imgUtil.AddRectangleMask(BGImage: &(self.imgProcess.targetImageMasked), PositionX: rect.minX, PositionY: rect.minY, Width: rect.width, Height: rect.height, MaskColor: CIColor.black)
//            }
//        }
//
//        self.imgProcess.SetFilter()
//
    }
    
}

//struct CharacterFrameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterFrameView(id: 1, rect: CGRect(x: 0,y: 0,width: 20,height: 20), char: "A")
//    }
//}
