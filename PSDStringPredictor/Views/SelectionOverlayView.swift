//
//  SelectionOverlayView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 10/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct SelectionOverlayView: View {
    @ObservedObject var interactive: InteractiveViewModel
    @ObservedObject var psdsVM : PsdsVM
//    @ObservedObject var regionVM: RegionProcessVM
    @State var startPos = CGPoint.zero
    @State var endPos = CGPoint.zero
    @State var width: CGFloat = 0
    @State var height: CGFloat = 0
    @State var show: Bool = false
    var body: some View {
        ZStack{
            Rectangle() //Rect for detect drag
                .fill(Color.white.opacity(0.01))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            show = true
                            startPos = gesture.startLocation
                            width = gesture.translation.width
                            height = gesture.translation.height 
                            interactive.selectionRect = CGRect.init(x: startPos.x, y: startPos.y , width: width, height: height)
                            interactive.selectionRect = interactive.selectionRect.standardized
                        }
                        .onEnded{ value in
                            //Selection mode for select string
                            show = false
                            endPos = value.location
                            if psdsVM.viewScale > 1{
                                interactive.selectionRect = CGRect.init(
                                    x: interactive.selectionRect.minX - psdsVM.fetchSelectedPsd().width * (psdsVM.viewScale - 1) / 2 ,
                                    y: interactive.selectionRect.minY - psdsVM.fetchSelectedPsd().height * (psdsVM.viewScale - 1) / 2  ,
                                    width: interactive.selectionRect.width ,
                                    height: interactive.selectionRect.height
                                ).standardized

                            }else{
//                                interactive.selectionRect = CGRect.init(x: interactive.selectionRect.minX, y: interactive.selectionRect.minY  , width: interactive.selectionRect.width , height: interactive.selectionRect.height)
                            }
//                            let selRect = CGRect.init(
//                                x: interactive.selectionRect.minX.rounded(),
//                                y: (psdsVM.selectedNSImage.size.height.rounded() - interactive.selectionRect.minY).rounded() ,
//                                width: interactive.selectionRect.width.rounded(),
//                                height: -interactive.selectionRect.height.rounded()
//                            ).standardized
//                            print(interactive.selectionRect)
//                            let tmp = psdsVM.viewScale
//                            psdsVM.viewScale = 1
                            CalcSelectedObject()
//                            psdsVM.viewScale = tmp
                        }
                    
                )
                
                .gesture(
                    TapGesture()
                        // Tap to clean up all selection
                        .onEnded { _ in
                            
                            psdsVM.selectedStrIDList.removeAll()
                        }
                )
             
            if show == true {
                Rectangle() //Rect for show
                    .fill(Color.green.opacity(0.3))
                    .frame(width: interactive.selectionRect.width, height: interactive.selectionRect.height)
                    .position(x: interactive.selectionRect.minX + interactive.selectionRect.width/2, y: (  interactive.selectionRect.minY + interactive.selectionRect.height/2))
                
            }
            
            
            
        }
    }
    
    func CalcSelectedObject(){
        psdsVM.selectedStrIDList.removeAll()
//        if psdsVM.GetSelectedPsd() == nil {return }
        guard let ids = psdsVM.psdStrDict[psdsVM.selectedPsdId] else {return  }

        for id in ids {
//            if obj.stringRect.contains(startPos) && obj.stringRect.contains(endPos){
//            }
            
            let tmpRect = CGRect.init(
                x: (psdsVM.fetchStringObject(strId: id).stringRect.origin.x),
                y: psdsVM.fetchSelectedPsd().height - psdsVM.fetchStringObject(strId: id).stringRect.origin.y - (psdsVM.fetchStringObject(strId: id).stringRect.height),
                width: psdsVM.fetchStringObject(strId: id).stringRect.width,
                height: psdsVM.fetchStringObject(strId: id).stringRect.height
            )
//            let tmpRect = rect
            if tmpRect.intersects(interactive.selectionRect)  {
                psdsVM.selectedStrIDList.append(psdsVM.fetchStringObject(strId: id).id)
            }
        }
        if psdsVM.selectedStrIDList.last != nil && psdsVM.fetchLastStringObjectFromSelectedPsd() != nil {
            psdsVM.tmpObjectForStringProperty = psdsVM.fetchLastStringObjectFromSelectedPsd().toObjectForStringProperty()
        }
        
    }
    
    func CalcTap(tapPoint: CGPoint){
        psdsVM.selectedStrIDList.removeAll()
        for objId in psdsVM.psdStrDict[psdsVM.selectedPsdId]! {
            if psdsVM.stringObjectDict[objId]!.stringRect.contains(tapPoint) {
                psdsVM.selectedStrIDList.append(objId)
            }
        }
    }
}
