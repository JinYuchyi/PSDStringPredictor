//
//  SelectionOverlayView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 10/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct SelectionOverlayView: View {
    @ObservedObject var interactive = interactiveViewModel
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
                            interactive.selectionRect = CGRect.init(x: startPos.x , y: startPos.y , width: width, height: height)
                            interactive.selectionRect = interactive.selectionRect.standardized
                        }
                        .onEnded{ value in
                                //Selection mode for select string
                                show = false
                                endPos = value.location
                                CalcSelectedObject()
                            
          
                        }
                )
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            psdsVM.selectedStrIDList.removeAll()
                            
                        }
                )
            Rectangle()
                //interactive.selectionRect
                .fill(Color.green.opacity(0.3))
                .frame(width: interactive.selectionRect.width, height: interactive.selectionRect.height)
                .position(x: interactive.selectionRect.minX + interactive.selectionRect.width/2, y: interactive.selectionRect.minY + interactive.selectionRect.height/2)
                //.frame(width: width, height: height)
                //.position(x: startPos.x + width/2, y: startPos.y + height/2)
                .IsHidden(condition: show)
            
            
        }
    }
    
    func CalcSelectedObject(){
        psdsVM.selectedStrIDList.removeAll()
        if psdsVM.GetSelectedPsd() == nil {return }
        
        for obj in psdsVM.GetSelectedPsd()!.stringObjects {
            if obj.stringRect.contains(startPos) && obj.stringRect.contains(endPos){
            }
            
            let tmpRect = CGRect.init(x: (obj.stringRect.origin.x ), y: (psdsVM.selectedNSImage.size.height - obj.stringRect.origin.y - obj.stringRect.height/2), width: obj.stringRect.width, height: obj.stringRect.height)
            if tmpRect.intersects(interactive.selectionRect)  {
                //print("intersects: \(tmpRect), \(interactive.selectionRect)")
                psdsVM.selectedStrIDList.append(obj.id)
            }
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
