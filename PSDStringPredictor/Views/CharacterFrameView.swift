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
    let imgUtil = ImageUtil.shared
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
                    .position(x: (item.minX + item.width/2), y: psdVM.selectedNSImage.size.height - item.minY - item.height/2)
                    .onTapGesture {
                        Tapped(rect: item)
                    }
            }
        }
        .onAppear(perform: {rectList = GetOnePageRectArray()})

    }
    
    var body: some View {
        CharFrameView()
    }

    
    func GetOnePageRectArray() -> [CGRect] {
//        guard let psdObj = psdVM.GetSelectedPsd() else {return []}
        var result = [CGRect]()
        guard let idList = psdVM.psdStrDict[psdVM.selectedPsdId] else {return []}
        for id in idList {
            result.append(contentsOf: psdVM.stringObjectDict[id]?.charRects ?? [])
        }
//        for obj in psdObj.stringObjects {
//            result.append(contentsOf: obj.charRects)
//        }
        return result
    }
    
    func Tapped(rect: CGRect){
        //Get tap character background color
        var theColor: CGColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        guard let idList = psdVM.psdStrDict[psdVM.selectedPsdId] else {return }
        for id in idList {
//            for str in psdVM.fetchStringObject(strId: id){
            if rect.intersects(psdVM.fetchStringObject(strId: id).stringRect) == true {
                theColor = psdVM.fetchStringObject(strId: id).bgColor
            }
//            }
        }
        
        
        if psdVM.maskDict[psdVM.selectedPsdId] == nil {
            psdVM.maskDict[psdVM.selectedPsdId] = []
        }
        let contain = psdVM.maskDict[psdVM.selectedPsdId]!.map({$0.rect}).contains(rect)
        //The tapped area is not in been tapped status
        if contain == false {
            let tempCharObj = charRectObject.init(rect: rect, color: theColor.toArray())
            psdVM.maskDict[psdVM.selectedPsdId]!.append(tempCharObj)
            psdVM.UpdateProcessedImage(psdId: psdVM.selectedPsdId)
        }else{
            //Tapped character already in been tapped status
            //Delete the tapped character in list
            let _index = psdVM.maskDict[psdVM.selectedPsdId]!.lastIndex(where: {$0.rect == rect})
            psdVM.maskDict[psdVM.selectedPsdId]!.remove(at: _index!)
            psdVM.UpdateProcessedImage(psdId: psdVM.selectedPsdId)
        }
        
        if psdVM.maskDict.count == 0 {
            psdVM.UpdateProcessedImage(psdId: psdVM.selectedPsdId)
        }
    }
    
    func AddCharRectMask(){

//
    }
    
}

