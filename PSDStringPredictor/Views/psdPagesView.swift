//
//  psdPagesView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 26/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct psdPagesView: View {
    
    @ObservedObject var psdVM = psdViewModel
    
    var body: some View {
        
        List{
//            ForEach (psdVM.psdPageObjectList) { item in
//                VStack{
//                    ZStack{
//                        psdPageView(psdPageObject: item)
//                        .frame(width: 300, alignment: .center)
//                    }
//                    Divider()
//                }
//            }
        }
    }
}

struct psdPagesView_Previews: PreviewProvider {
    static var previews: some View {
        psdPagesView()
    }
}
