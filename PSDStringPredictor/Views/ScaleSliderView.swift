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
        HStack {
                Slider(
                    value: $psdsVM.viewScale,
                    in: 0.5...3.0,
                    
//                    step: 0.1,
//                    onEditingChanged: { v in
//                        scale = v
//                    },
                    minimumValueLabel: Text("0.5"),
                    maximumValueLabel: Text("3.0")
                ){
                    Text("Zoom")
                }
            Button("Reset", action: {
                psdsVM.viewScale = 1
            })
            }
//        .accentColor(.red)
        .frame(width: 300, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.black.opacity(0.3)))
        .padding()


    }
}

//struct ScaleSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScaleSliderView()
//    }
//}
