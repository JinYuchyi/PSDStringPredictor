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
    @State var posY = 0
    @State var width = 0
    @State var height = 0
    var body: some View {
        
        Rectangle()
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        startPos = gesture.startLocation
                        //interactive.CalcSelectionRect(gesture.translation)
                    }
            )
        
    }
}

//struct SelectionOverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionOverlayView()
//    }
//}
