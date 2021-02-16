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
    //@State var show: Bool = false
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.green.opacity(0.5))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            regionStartPos = gesture.startLocation
                            regionWidth = gesture.translation.width
                            regionHeight = gesture.translation.height
                            interactive.selectionRect = CGRect.init(x: regionStartPos.x , y: regionStartPos.y , width: regionWidth, height: regionHeight)
                            interactive.selectionRect = interactive.selectionRect.standardized
                        }
                        .onEnded{ value in
                            regionEndPos =  value.location
                            let cropRect = CGRect.init(x: interactive.selectionRect.minX.rounded(), y: (psdsVM.selectedNSImage.size.height - interactive.selectionRect.minY).rounded(), width: interactive.selectionRect.width.rounded(), height: -interactive.selectionRect.height.rounded()).standardized
                            psdsVM.fetchRegionStringObjects(rect: cropRect, psdId: psdsVM.selectedPsdId)

    
                        }
                )
                .mask(
                    Rectangle()
                        //interactive.selectionRect
                        .fill(Color.green.opacity(0.5))
                        .frame(width: interactive.selectionRect.width, height: interactive.selectionRect.height)
                        .position(x: interactive.selectionRect.minX + interactive.selectionRect.width/2, y: interactive.selectionRect.minY + interactive.selectionRect.height/2)
                )

            
                         
            
        }
    }
    
    
    
    func invertedMask(in rect: CGRect, addRect: CGRect) -> Path {
        var shape = Rectangle().path(in: rect)
        shape.addPath(Rectangle().path(in: addRect))
        return shape
    }
}


