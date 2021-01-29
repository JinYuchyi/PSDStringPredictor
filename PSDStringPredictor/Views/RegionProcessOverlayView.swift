//
//  regionProcessOverlayView.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 29/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct RegionProcessOverlayView: View {
    
    @ObservedObject var interactive = interactiveViewModel
    @ObservedObject var psdsVM : PsdsVM
    @ObservedObject var regionProcessVM : RegionProcessVM
    @State var startPos = CGPoint.zero
    @State var endPos = CGPoint.zero
    @State var width: CGFloat = 0
    @State var height: CGFloat = 0
    @State var show: Bool = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            startPos = gesture.startLocation
                            width = gesture.translation.width
                            height = gesture.translation.height
                            interactive.selectionRect = CGRect.init(x: startPos.x , y: startPos.y , width: width, height: height)
                            interactive.selectionRect = interactive.selectionRect.standardized
                        }
                        .onEnded{ value in
                            endPos = value.location
                            //TODO: ReCalculate
                        }
                )
                
//            Rectangle()
//                .fill(Color.green.opacity(0.3))
//                .frame(width: interactive.selectionRect.width, height: interactive.selectionRect.height)
//                .position(x: interactive.selectionRect.minX + interactive.selectionRect.width/2, y: interactive.selectionRect.minY + interactive.selectionRect.height/2)
//                .IsHidden(condition: show)
            
            
        }
    }
}


