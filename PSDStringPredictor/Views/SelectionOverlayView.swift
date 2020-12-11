//
//  SelectionOverlayView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 10/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct SelectionOverlayView: View {
    @ObservedObject var interactive = InteractiveViewModel()
    @State var startPos = CGPoint.zero
    @State var width: CGFloat = 0
    @State var height: CGFloat = 0
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white.opacity(0.01))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            startPos = gesture.startLocation
                            width = gesture.translation.width
                            height = gesture.translation.height
                        }
                )
            Rectangle()
                
                .fill(Color.green.opacity(0.3))
                .frame(width: width, height: height)
                .position(x: startPos.x, y: startPos.y)
                //.IsHidden(condition: width != 0)
        }
    }
}

//struct SelectionOverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionOverlayView()
//    }
//}
