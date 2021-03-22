//
//  regionProcessOverlayView.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 29/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct RegionProcessOverlayView: View {
    
    @ObservedObject var interactive: InteractiveViewModel
    @ObservedObject var psdsVM : PsdsVM
    @ObservedObject var regionProcessVM : RegionProcessVM 
    @State var regionStartPos = CGPoint.zero
    @State var regionEndPos = CGPoint.zero
    @State var regionWidth: CGFloat = 0
    @State var regionHeight: CGFloat = 0
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(regionProcessVM.regionButtonActive == true ? (Color.blue.opacity(0.5)) : (Color.white.opacity(0.01)))
                .gesture(
                    DragGesture() //Drag to region process
                        .onChanged { gesture in
                            regionStartPos = gesture.startLocation
                            
                            regionWidth = gesture.translation.width
                            regionHeight = gesture.translation.height
                            interactive.selectionRect = CGRect.init(x: regionStartPos.x , y: regionStartPos.y , width: regionWidth, height: regionHeight)
                            interactive.selectionRect = interactive.selectionRect.standardized
                        }
                        .onEnded{ value in
                            regionEndPos =  value.location
                            let cropRect = CGRect.init(
                                x: interactive.selectionRect.minX.rounded(),
                                y: (psdsVM.selectedNSImage.size.height.rounded() - interactive.selectionRect.minY).rounded() ,
                                width: interactive.selectionRect.width.rounded(),
                                height: -interactive.selectionRect.height.rounded()
                            ).standardized
                            _ = psdsVM.fetchRegionStringObjects(rect: cropRect, psdId: psdsVM.selectedPsdId)

                            regionProcessVM.regionButtonActive = false
                            psdsVM.IndicatorText = ""


                        }
                )
                .mask(
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: interactive.selectionRect.width , height: interactive.selectionRect.height  )
                        .position(x: (interactive.selectionRect.minX + interactive.selectionRect.width/2) , y: (interactive.selectionRect.minY + interactive.selectionRect.height/2) )
                )
        }
        .frame(width: psdsVM.fetchSelectedPsd().width  , height: psdsVM.fetchSelectedPsd().height )
        .IsHidden(condition: regionProcessVM.regionButtonActive == true)

    }
    
    
    
    func invertedMask(in rect: CGRect, addRect: CGRect) -> Path {
        var shape = Rectangle().path(in: rect)
        shape.addPath(Rectangle().path(in: addRect))
        return shape
    }
}


