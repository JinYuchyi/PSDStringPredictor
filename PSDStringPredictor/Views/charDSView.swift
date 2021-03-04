//
//  charDSView.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 4/3/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI
import CoreImage

struct charDSView: View {
    
    @State var str: String = ""
    @ObservedObject var psdsVM : PsdsVM
//    let img: CIImage
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5, style: .continuous).colorMultiply(Color.black)
                 
            
            VStack{
                TextField("", text: $str, onCommit: {})
                    .padding()
                HStack{
                    Button("Save", action: {psdsVM.saveCharDS(img: psdsVM.charImageDSWillBeSaved, str: str)})
                    Button("Cancel", action: {psdsVM.charDSWindowShow = false})
                }
            }
        }
         .frame(width: 500, height: 400, alignment: .center)
        .IsHidden(condition: psdsVM.charDSWindowShow )
    }
    
}


//struct charDSView_Previews: PreviewProvider {
//    static var previews: some View {
//        charDSView(str: PsdsVM())
//    }
//}
