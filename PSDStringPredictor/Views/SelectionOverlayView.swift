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
            Rectangle()
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
                                interactive.selectionRect = CGRect.init(x: interactive.selectionRect.minX - psdsVM.GetSelectedPsd()!.width * (psdsVM.viewScale - 1) / 2 , y: interactive.selectionRect.minY - psdsVM.GetSelectedPsd()!.height * (psdsVM.viewScale - 1) / 2 , width: interactive.selectionRect.width * psdsVM.viewScale , height: interactive.selectionRect.height * psdsVM.viewScale )

                            }else{
                                interactive.selectionRect = CGRect.init(x: interactive.selectionRect.minX, y: interactive.selectionRect.minY  , width: interactive.selectionRect.width , height: interactive.selectionRect.height)
                            }
//                            let selRect = CGRect.init(
//                                x: interactive.selectionRect.minX.rounded(),
//                                y: (psdsVM.selectedNSImage.size.height.rounded() - interactive.selectionRect.minY).rounded() ,
//                                width: interactive.selectionRect.width.rounded(),
//                                height: -interactive.selectionRect.height.rounded()
//                            ).standardized
                            print(interactive.selectionRect)
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
                Rectangle()
                    //interactive.selectionRect
                    .fill(Color.green.opacity(0.3))
                    .frame(width: interactive.selectionRect.width, height: interactive.selectionRect.height)
                    .position(x: interactive.selectionRect.minX + interactive.selectionRect.width/2, y: interactive.selectionRect.minY + interactive.selectionRect.height/2)
                
            }
            
            
            
        }
    }
    
    func CalcSelectedObject(){
        psdsVM.selectedStrIDList.removeAll()
        if psdsVM.GetSelectedPsd() == nil {return }
        
        for obj in psdsVM.GetSelectedPsd()!.stringObjects {
            if obj.stringRect.contains(startPos) && obj.stringRect.contains(endPos){
            }
            
            let tmpRect = CGRect.init(
                x: (obj.stringRect.minX ),
                y: (psdsVM.selectedNSImage.size.height - obj.stringRect.minY - obj.stringRect.height/2),
                width: obj.stringRect.width,
                height: obj.stringRect.height
            )
//            let tmpRect = rect
            if tmpRect.intersects(interactive.selectionRect)  {
                psdsVM.selectedStrIDList.append(obj.id)
            }
        }
        if psdsVM.GetSelectedPsd() != nil && psdsVM.selectedStrIDList.last != nil && psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!) != nil {
            psdsVM.tmpObjectForStringProperty = psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!)!.toObjectForStringProperty()
        }
        
    }
    
    func CalcTap(tapPoint: CGPoint){
        psdsVM.selectedStrIDList.removeAll()
        for obj in psdsVM.GetSelectedPsd()!.stringObjects {
            if obj.stringRect.contains(tapPoint) {
                psdsVM.selectedStrIDList.append(obj.id)
            }
        }
    }
}
