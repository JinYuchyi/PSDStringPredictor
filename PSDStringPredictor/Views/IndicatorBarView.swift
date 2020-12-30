//
//  IndicatorView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct IndicatorView: View {
    @ObservedObject var stringObjectVM = stringObjectViewModel
    @ObservedObject var ocrVM = OCR()
    @State var start = false
    var body: some View {
        ZStack {
            Group{
                RoundedRectangle(cornerRadius: 10)
                    .fill(DataStore.colorMode == 2 ? Color.black : Color.white).opacity(0.5)
                Text(stringObjectVM.indicatorTitle)
                    .bold()
                    //.shadow(color: Color.black.opacity(0.5), radius: 1, y: 2 )
                    
                    .offset(x: 0, y: -25)
                
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color(.systemGray), lineWidth: 3)
                    .frame(width: 500, height: 3)
                
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: 500, height: 3)
                    .offset(x: stringObjectVM.indicatorTitle.isEmpty != false ? -500 : 500, y: 0)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
                    .mask(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color(.systemGray), lineWidth: 3)
                            .frame(width: 500, height: 3)
                    )
                
                Button(action: {ocrVM.StopBackendWork()}) {
                    Text("Abort")
                }
                .frame(width: 550, height: 100, alignment: .bottom)
                .padding()
                
            }
            .opacity(stringObjectVM.indicatorTitle == "" ? 0 : 1)
            
        }
        .frame(width: 550, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        //           .onAppear() {
        //                Active()
        //           }
    }
    
    
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
