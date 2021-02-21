//
//  ScaleSliderView.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 22/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ScaleSliderView: View {
    
//    @Binding var scale: CGFloat
    @ObservedObject var psdsVM: PsdsVM

    var body: some View {
        VStack {
                Slider(
                    value: $psdsVM.viewScale,
                    in: 0.5...3.0,
                    
                    step: 0.5,
//                    onEditingChanged: { v in
//                        scale = v
//                    },
                    minimumValueLabel: Text("0.5"),
                    maximumValueLabel: Text("3.0")
                ){
                    Text("Scale")
                }
                //Text("\(scale)")
                    //.foregroundColor(isEditing ? .red : .blue)
            }
        .frame(width: 300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

//struct ScaleSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScaleSliderView()
//    }
//}
