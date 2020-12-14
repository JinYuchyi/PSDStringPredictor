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
    @ObservedObject var objVM = stringObjectViewModel
    @ObservedObject var imageVM = imageProcessViewModel
    @State var startPos = CGPoint.zero
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
                            interactive.selectionRect = CGRect.init(x: startPos.x + width/2, y: startPos.y + height/2, width: width, height: height)
                            interactive.selectionRect = interactive.selectionRect.standardized

                        }
                        .onEnded{ value in
//                            interactive.selectionRect = CGRect.init(x: startPos.x + width/2, y: startPos.y + height/2, width: width, height: height)
//                            interactive.selectionRect = interactive.selectionRect.standardized
                            show = false
                            CalcSelectedObject()

                            print(interactive.selectionRect)
                        }
                )
            Rectangle()
                //interactive.selectionRect
                .fill(Color.green.opacity(0.3))
                .frame(width: interactive.selectionRect.width, height: interactive.selectionRect.height)
                .position(x: interactive.selectionRect.minX, y: interactive.selectionRect.minY)
                //.frame(width: width, height: height)
                //.position(x: startPos.x + width/2, y: startPos.y + height/2)
                .IsHidden(condition: show)
            
            ForEach (objVM.stringObjectListData) { item in
                Rectangle()
                    .fill(Color.red)
                    .frame(width: item.stringRect.width, height: item.stringRect.height)
                    .position(x: (item.stringRect.origin.x + item.stringRect.width/2), y: (imageVM.GetTargetImageSize()[1] - item.stringRect.origin.y - item.stringRect.height/2))
                    
            }
            
        }
    }
    
    func CalcSelectedObject(){
        objVM.selectedStringObjectList.removeAll()
        for obj in objVM.stringObjectListData {
            //print("checking: \(obj.stringRect), \(interactive.selectionRect)")
//            var tempRect = CGRect.init(x: interactive.selectionRect.minX, y:  interactive.selectionRect.minY, width: interactive.selectionRect.width, height: interactive.selectionRect.height)
            let tmpRect = CGRect.init(x: (obj.stringRect.origin.x + obj.stringRect.width/2), y: (imageVM.GetTargetImageSize()[1] - obj.stringRect.origin.y - obj.stringRect.height/2), width: obj.stringRect.width, height: obj.stringRect.height)
            if tmpRect.intersects(interactive.selectionRect) {
                print("intersects: \(tmpRect), \(interactive.selectionRect)")
                objVM.selectedStringObjectList.append(obj)
            }
        }
    }
}

//struct SelectionOverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionOverlayView()
//    }
//}
