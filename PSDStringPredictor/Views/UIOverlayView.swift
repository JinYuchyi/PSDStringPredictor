//
//  UIOverlayView.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 19/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct UIOverlayView: View {
    @Binding var showPatchLayer: Bool
    var body: some View {
        Toggle(isOn: $showPatchLayer) {
            Text("Show Block layers")
                .fixedSize()
                .shadow(radius: 1)
        }
        .padding()
    }
}

//struct UIOverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        UIOverlayView()
//    }
//}
