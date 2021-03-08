//
//  GridView.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 8/3/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var psdsVM: PsdsVM
    var body: some View {
        Rectangle()
            .position(x: 0, y: 0)
            .frame(width: 1, height: psdsVM.GetSelectedPsd()?.height, alignment: .center)
            .foregroundColor(.red)
    }
}
//
//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView()
//    }
//}
