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
                .frame(alignment: .leading)
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.green, lineWidth: 2)
                .frame(width: width, height: 2)
                .offset(x: -width + psdsVM.prograssScale * width, y: 0)
                //.animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
                .mask(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color(.systemGray), lineWidth: 2)
                        .frame(width: width, height: 2)
                )
        }
        .IsHidden(condition: psdsVM.IndicatorText != "")

    }
}

//struct PrograssView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrograssView()
//    }
//}
