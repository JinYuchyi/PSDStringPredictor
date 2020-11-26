//
//  psdPagesView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 26/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct psdPagesView: View {
    
    @ObservedObject var stringObjectVM = stringObjectViewModel
    
    var body: some View {
        
        List{
            ForEach (stringObjectVM.psdPageObjectList) { item in
                VStack{
                    ZStack{
                        psdPageView(psdPageObjectList: item)
                        .frame(width: 300, alignment: .center)
                        Text("􀁢")
                            .font(.system(size: 30))
                            .frame(width: 300, alignment: .topTrailing)
                            .offset(x: -20, y: 0)
                            .foregroundColor(item.isCommitted == true ? .green : .gray)
                    }
                    Divider()
                }
            }
        }
    }
}

struct psdPagesView_Previews: PreviewProvider {
    static var previews: some View {
        psdPagesView()
    }
}
