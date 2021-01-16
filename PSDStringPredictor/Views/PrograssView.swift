//
//  PrograssView.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 16/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct PrograssView: View {
    @ObservedObject var psdsVM : PsdsVM
    let width: CGFloat = 200
    var body: some View {
        //psdVM.prograssScale
        VStack{
            Text(psdsVM.IndicatorText)
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.green, lineWidth: 3)
                .frame(width: width, height: 3)
                .offset(x: -width + psdsVM.prograssScale * width, y: 0)
                //.animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
                .mask(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(.systemGray), lineWidth: 3)
                        .frame(width: width, height: 3)
                )
        }
        
    }
}

//struct PrograssView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrograssView()
//    }
//}
