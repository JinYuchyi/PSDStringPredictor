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
    
    var body: some View {
        ZStack {
            Group{
            Text(stringObjectVM.indicatorTitle)
                //.font(.system(.body, design: .))
                .bold()
                .offset(x: 0, y: -25)
            
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color(.systemGray), lineWidth: 3)
                .frame(width: 500, height: 3)
            
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.green, lineWidth: 3)
                .frame(width: 500, height: 3)
                .offset(x: Active() ? 500 : -500, y: 0)
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
                .mask(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(.systemGray), lineWidth: 3)
                        .frame(width: 500, height: 3)
                )
            }
            .IsHidden(condition: Active())

            
        }
        .frame(width: 550, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        //           .onAppear() {
        //                Active()
        //           }
    }
    
    func Active() -> Bool{
        if (stringObjectVM.indicatorTitle == ""){
            return false
        }else{
            return true
        }
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
