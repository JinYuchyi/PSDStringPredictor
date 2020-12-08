//
//  IndicatorCircleView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct IndicatorCircleView: View {
    @State private var     isLoading = false
    
    var body: some View {

//        ZStack {
//            Circle()
//                .stroke(Color(.systemGray).opacity(0.3), lineWidth: 14)
//
//            Circle()
//
//                .trim(from: 0, to: 0.2)
//                .stroke(Color.green, lineWidth: 7)
//
//                .rotationEffect((.degrees(isLoading ? 360 : 0)))
//
//                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
//
//                .onAppear() {
//                    self.isLoading = true
//                }
//            Text("Loading ...")
//        }
//        .padding()
        
        Circle()
            
            .trim(from: 0, to: 0.2)
            .stroke(Color.green, lineWidth: 7)
            
            .rotationEffect((.degrees(isLoading ? 360 : 0)))
            
            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))

            .onAppear() {
                self.isLoading = true
            }
        
    }
    
    
}

struct IndicatorCircleView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorCircleView()
    }
}
