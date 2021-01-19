//
//  PrograssView.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 16/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct PrograssView1: View {
    @ObservedObject var psdsVM : PsdsVM =  PsdsVM()
    let width: CGFloat = 500
    @State private var isLoading = false
    
    var body: some View {
        //psdVM.prograssScale
        ZStack {
         
                    Text("Loading")
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .offset(x: 0, y: -25)
         
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(.systemGray), lineWidth: 3)
                        .frame(width: 250, height: 3)
         
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.green)
                        .frame(width: 30, height: 3)
                        //.scaleEffect(isLoading ? 1.5 : 1)
                        
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                        .onAppear() {
                            isLoading = true
                        }
                        
                }
        
        
        //.IsHidden(condition: psdsVM.IndicatorText != "")
        
    }
}

struct PrograssView_Previews: PreviewProvider {
    static var previews: some View {
        PrograssView1()
    }
}
