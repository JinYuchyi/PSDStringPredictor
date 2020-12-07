//
//  IndicatorView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct IndicatorView: View {
    @ObservedObject var imageProcessVM = imageProcessViewModel
    var body: some View {
        ZStack{
//            LinearGradient(gradient: Gradient(colors: [.init( red: 0, green: 0, blue: 0, opacity: 0), .black]), startPoint: .top, endPoint: .bottom)
//                .frame(height:100)
            VStack{
                //Text(imageProcessVM.indicatorTitle)
                //Spacer().frame(height:-30)
                
                HStack{
                    Capsule()
                        .fill(Color.green)
                        .frame(width: 1000 * CGFloat(imageProcessVM.indicatorIndex) / 100, height: 5)
                    Text("\(imageProcessVM.indicatorIndex)%")
                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0)
                }
                .frame(width: 1000, height: 100, alignment: .leading)
                
            }
        }
        .IsHidden(condition: IsShow())
    }
    
    func IsShow() -> Bool{
        if (imageProcessVM.indicatorIndex == 0 || imageProcessVM.indicatorIndex >= 100){
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
