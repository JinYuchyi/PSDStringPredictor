//
//  psdPageView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 26/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct psdPageView: View {
    //var psdPageObject: psdPage
    @State var isCommitted = false
    //let tmpObj = psdPage(id: UUID(), name: "xxxx.psd", image: CIImage.init(), isCommitted: false)
    var body: some View {
        //GeometryReader { geometry in
            ZStack{
                VStack{
                    Rectangle()
                        .frame(width: 100, height: 150, alignment: .center)
                        .foregroundColor(Color.gray)
                    Text(psdPageObject.name)
                        .foregroundColor(Color.gray)
                }
                Text("􀁢")
                    .font(.system(size: 30))
                    .frame(width: 300, alignment: .topTrailing)
                    .offset(x: -20, y: 0)
                    .foregroundColor(self.isCommitted == true ? .green : .gray)
                    .onTapGesture {
                        isCommitted = !isCommitted
                    }
//                Text("􀁣")
//                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            
        
    }
    
   
    
}

//struct psdPageView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        psdPageView(psdPageObj: tmpObj)
//    }
//}
